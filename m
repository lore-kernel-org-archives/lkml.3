Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaCYQKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:10:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60750 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbaCYQKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:10:33 -0400
Date: Tue, 25 Mar 2014 17:10:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nick Krause <nickkrause@sympatico.ca>
Cc: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: Re: RESEND: PATCH[60485 Bug adding breakpoint for msi-pci]
Message-ID: <20140325161028.GA6393@pd.tnic>
References: <SNT145-W982FA6E38A0213DE61456DA5780@phx.gbl>
 <SNT145-W3682AF4AA1AE6F941FDC1BA57A0@phx.gbl>
 <SNT145-W659480DCC260415F2FA288A5650@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SNT145-W659480DCC260415F2FA288A5650@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 02:27:04AM +0000, Nick Krause wrote:
> > Here is my new patch as corrected for the the bug 60845.
> > https://bugzilla.kernel.org/show_bug.cgi?id=60845
> > This is the link to the bug and my comments / conversation on to get the corrections needed.
> >  Below is my patch for the bug, please let me know if it gets added finally Alan .
> >
> >  --- linux-3.13.6/arch/mips/pci/msi-octeon.c.orig    2014-03-22 17:32:44.762754254 -0400
> >  +++ linux-3.13.6/arch/mips/pci/msi-octeon.c    2014-03-22 17:34:19.974753699 -0400
> >  @@ -150,6 +150,7 @@ msi_irq_allocated:
> >           msg.address_lo =
> >               ((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
> >           msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV)>> 32;
> >  +        break;

Looks like this has been fixed already: 7f02c463057fc527f52066742b84d9d89b22e83d

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
