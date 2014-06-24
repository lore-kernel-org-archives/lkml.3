Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaFXEVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:21:05 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:50550 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaFXEVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:21:04 -0400
Message-ID: <53A8FCA3.8000107@synopsys.com>
Date: Tue, 24 Jun 2014 09:50:51 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>
Subject: Re: ARC cross compiler hosting on kernel.org
References: <5285B64E.7030507@synopsys.com>
In-Reply-To: <5285B64E.7030507@synopsys.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Friday 15 November 2013 11:21 AM, Vineet Gupta wrote:
> Hi Tony,
> 
> Can you please host a ARC cross compiler on
> https://www.kernel.org/pub/tools/crosstool
> 
> Mainline buildroot supports ARC (alas that build system doesn't generate a
> relocatable toolchain).
> 
> Or you can simply use our homegrown build-system to checkout and build tools
> (which can even do a relocatable toolchain provided you have patchelf installed)
> 
> git clone git@github.com:foss-for-synopsys-dwc-arc-processors/toolchain.git
> cd toolchain
> ./build-all.sh --auto-checkout --auto-pull --rel-rpaths --no-elf32 \
> --target-cflags "-gdwarf-2"
> 
> ARC defconfig requires an INITRAMFS at a relative path. You can either disable it
> (I have a patch queued up for a !RAMFS defconfig too).
> 
> Let me know if you run into any issues.
> 
> Thx,
> -Vineet
> 

Can you please look at this one or let me know who could help with this.

Thx,
-Vineet
