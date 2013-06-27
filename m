Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3F0OXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:23:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3F0OXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:23:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 16:22:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Leif Lindholm <leif.lindholm@linaro.org>, linux-efi@vger.kernel.org,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        matt.fleming@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org> <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
In-Reply-To: <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306271622.26494.arnd@arndb.de>
X-Provags-ID: V02:K0:xhVg3KtqcIZv2KKn+faLTS+nOEKE41E8H9L1J0UBXUO
 eGQ3MKhaI+K037TDZ6YyN2skeLCHSqL9wDQrtnFsyH3LvPlM8o
 Zc4PsD7nQJPN0Xrxr1aFYeEP5nKGKrFQt1hdzEIJHRDkecveou
 ZSVkkNvuJXD5YaLjkkgmxNnFVQlP6Pd2m3bJAZ2QQul+CASslh
 jhezOfl2mngwZfct5iLC4rEzBShrFHrl/+NmABN5NlGpKur+/1
 maB8twiAc9e43+Nnph3g/9MqEm1u4PMd1ocOEEpPcJDbG4k4dt
 40qnqc7m2Yx9H3Mdc+Ev8KzXT9NiPfAa43qOVs0WvU59tv4z3P
 CvpeZ+A8ZLw3T6HDpoBY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Grant Likely wrote:
> > index 0000000..5c48271
> > --- /dev/null
> > +++ b/Documentation/arm/uefi.txt
> > @@ -0,0 +1,39 @@
> > +The nomenclature EFI and UEFI are used interchangeably in this document.
> > +
> > +The implementation depends on receiving pointers to the UEFI memory map
> > +and System Table in a Flattened Device Tree - so is only available with
> > +CONFIG_OF.
> > +
> > +It (early) parses the FDT for the following parameters:
> 
> Need to state which node these properties can be found in. I recommend /chosen
> 
> I would also prefix all of the following properties with "linux,"
> since they are very much about what the Linux kernel needs for
> booting. EFI stub will be creating these properties specifically for
> Linux, and the LinuxLoader should do the same (until we eventually
> kill it).

Why not make it a separate /efi node instead, mirroring what we
have for hypervisor specific information and things like rtas?

	Arnd
