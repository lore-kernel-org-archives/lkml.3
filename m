Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3BKKif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:38:35 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44075 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3BKKie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <201302072312.45988.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302070833.15443.arnd@arndb.de>
	<CAHTX3dLuAhpy-Yk10scRKrfRrbh+ZZs-hgFLAFn0Vj562V0Cew@mail.gmail.com>
	<201302072312.45988.arnd@arndb.de>
Date: Mon, 11 Feb 2013 11:38:32 +0100
Message-ID: <CAHTX3dK1Buz3Yh8NTrpsB2X6_17EYT5augOsaLy8_OZQHAOUyw@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/8 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 07 February 2013, Michal Simek wrote:
>> Subject: "asm-generic: io: Fix ioread16/32be and iowrite16/32be"
>
> Ok, thanks. If you don't mind, I think this can just go with the other patches
> for xsysace that come out of this discussion.

I want to move microblaze to use this asm-generic/io.h that's why I
prefer to send
this with microblaze patch directly to Linus. For me this make more sense that
with sending block device driver changes.

What do you think?

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
