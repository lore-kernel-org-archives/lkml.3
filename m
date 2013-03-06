Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3CFTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:33:14 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:57929 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3CFTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:33:13 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al5hAPqYN1FV5qjOPGdsb2JhbABEh12EfbdoAwGBWRcDAQEBATg0gioBAQQBOhwjEAgDISUPBSUKGoggCrxPFY12gQEHgl9hA5ZKhgiNcg
X-IronPort-AV: E=Sophos;i="4.84,797,1355094000"; 
   d="scan'208";a="508649073"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 20:36:12 +0100
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306193612.GA513@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
 <20130306080642.GA535@polaris.bitmath.org>
 <51370990.5040508@linux.intel.com>
 <20130306100743.GA407@polaris.bitmath.org>
 <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

> >> Can you get a boot log with "debug memblock=debug" from the last
> >> successful commit point?  Are you booting EFI or BootCamp?
> >
> > Attached the dmesg log, booting from f763ad1 which is on top of
> > 3.7-rc6. I am booting with EFI_STUB, straight into the kernel.
> > The command line and modules are built in.
> 
> will check that EFI_STUB path.
> 
> Can you check bootloader like grub.efi ?

I checked, same story. I tried without EFI_STUB, no joy. I ran with
and without nouveau, just in case. Without the patch, everything
works. With the patch, nothing works, and no output at all.

With a bit of luck, I could maybe get the first lines of output using
grub.efi, but frankly I cannot remember if that ever worked on this
machine.

Henrik
