Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaCYCcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:32:13 -0400
Received: from snt0-omc2-s41.snt0.hotmail.com ([65.54.61.92]:48841 "EHLO
	snt0-omc2-s41.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbaCYCcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:32:12 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 22:32:12 EDT
X-TMN: [lCYq4kqWEb7V74z6N1FYWLt3/rFfdptX]
X-Originating-Email: [nickkrause@sympatico.ca]
Message-ID: <SNT145-W659480DCC260415F2FA288A5650@phx.gbl>
From: Nick Krause <nickkrause@sympatico.ca>
To: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: RESEND: PATCH[60485 Bug adding breakpoint for msi-pci]
Date: Tue, 25 Mar 2014 02:27:04 +0000
Importance: Normal
In-Reply-To: <SNT145-W3682AF4AA1AE6F941FDC1BA57A0@phx.gbl>
References: <SNT145-W982FA6E38A0213DE61456DA5780@phx.gbl>,<SNT145-W3682AF4AA1AE6F941FDC1BA57A0@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Mar 2014 02:27:05.0288 (UTC) FILETIME=[B6841480:01CF47D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----------------------------------------
> From: nickkrause@sympatico.ca
> To: alan@lxorguk.ukuu.org.uk
> CC: linux-mips@linux-mips.org; linux-kernel@vger.kernel.org; ralf@linux-mips.org
> Subject: RE: PATCH[60485 Bug adding breakpoint]
> Date: Mon, 24 Mar 2014 00:19:29 +0000
>
>
>
>
>
> Here is my new patch as corrected for the the bug 60845.
> https://bugzilla.kernel.org/show_bug.cgi?id=60845
> This is the link to the bug and my comments / conversation on to get the corrections needed.
>  Below is my patch for the bug, please let me know if it gets added finally Alan .
>
>  --- linux-3.13.6/arch/mips/pci/msi-octeon.c.orig    2014-03-22 17:32:44.762754254 -0400
>  +++ linux-3.13.6/arch/mips/pci/msi-octeon.c    2014-03-22 17:34:19.974753699 -0400
>  @@ -150,6 +150,7 @@ msi_irq_allocated:
>           msg.address_lo =
>               ((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
>           msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV)>> 32;
>  +        break;
>       case OCTEON_DMA_BAR_TYPE_BIG:
>         /* When using big bar, Bar 0 is based at 0 */
>           msg.address_lo = (0 + CVMX_PCI_MSI_RCV) & 0xffffffff; Signed-off-by: nickkrause@sympatico.ca
> Nick
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
 		 	   		  