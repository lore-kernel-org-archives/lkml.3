Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3K0PRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:17:37 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36899 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3K0PRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:17:33 -0500
X-Auth-Info: fIRBDkqw0mHShebZ11YYWwdAjASK59Qyh5mvueuEIrc=
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Evolution of Linux kernel sizes
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com>
References: <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com>
Comments: In-reply-to Geert Uytterhoeven <geert@linux-m68k.org>
   message dated "Wed, 27 Nov 2013 10:35:25 +0100."
Date: Wed, 27 Nov 2013 16:17:26 +0100
Message-Id: <20131127151726.DCE57380416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Geert,

In message <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com> you wrote:
>
> Below are the static kernel sizes (as reported by "size") for m68k
> multi-platform kernels (m68k/multi_defconfig), for kernel versions
> 2.6.28 to 3.12:
> 
>    text    data     bss     dec     hex filename
...
> 4010686  220476  190220 4421382  437706 vmlinux-v3.12

It's even more dramatic if you look further back.  The U-Boot README
still has examples of 2.4.4 kernels for PowerPC _including_ network
support:

        -> tools/mkimage -l examples/uImage.TQM850L
        Image Name:   2.4.4 kernel for TQM850L
        Created:      Wed Jul 19 02:34:59 2000
        Image Type:   PowerPC Linux Kernel Image (gzip compressed)
        Data Size:    335725 Bytes = 327.86 kB = 0.32 MB
        Load Address: 0x00000000
        Entry Point:  0x00000000

resp. the same kernel using an uncompressed image:

	Image Type:   PowerPC Linux Kernel Image (uncompressed)
	Data Size:    792160 Bytes = 773.59 kB = 0.76 MB

Those were the days then, 13 years ago...

Today:

	Image Name:   Linux-3.12.0-11101-gfe9baba
	Created:      Wed Nov 27 15:05:33 2013
	Image Type:   PowerPC Linux Kernel Image (gzip compressed)
	Data Size:    1509145 Bytes = 1473.77 kB = 1.44 MB
	Load Address: 00000000
	Entry Point:  00000000

	Image Type:   PowerPC Linux Kernel Image (uncompressed)
	Data Size:    3172240 Bytes = 3097.89 kB = 3.03 MB

Compressed:   1509145 / 335725 = 4.50
Uncompressed: 3172240 / 792160 = 4.00



[1] http://git.denx.de/?p=u-boot.git;a=blob;f=README#l5142

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I think it's a new feature. Don't tell anyone it was an accident. :-)
  -- Larry Wall on s/foo/bar/eieio in <10911@jpl-devvax.JPL.NASA.GOV>
