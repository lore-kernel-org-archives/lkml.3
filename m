Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3I3VG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:06:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54005 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab3I3VGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:06:54 -0400
Date: Mon, 30 Sep 2013 23:06:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130930210646.GF19411@pd.tnic>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
 <20130930203505.GA6116@redhat.com>
 <20130930204154.GE19411@pd.tnic>
 <20130930204642.GB6116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130930204642.GB6116@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:46:42PM -0400, Vivek Goyal wrote:
> On Mon, Sep 30, 2013 at 10:41:54PM +0200, Borislav Petkov wrote:
> 
> [..]
> > hpa, so, for the struct efi_mapping thing to work, I will have to grep
> > dmesg of the first kernel to get an output like the one below, filter
> > the runtime regions so that I can build the struct efi_mapping array of
> > mem regions which I pass on to the second, kexec kernel with setup_data.
> 
> Any data you need to pass to second kernel will have to be exported to
> user space either using /sys or /proc so that kexec-tools can parse it.

And I cannot parse dmesg? Because I have all the info there already.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
