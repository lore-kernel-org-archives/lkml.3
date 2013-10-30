Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3J3B5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:57:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3J3B5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:57:39 -0400
Message-ID: <52706790.9090602@infradead.org>
Date: Tue, 29 Oct 2013 18:57:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: mmotm 2013-10-29-16-22 uploaded (input)
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 16:23, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-10-29-16-22 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (3.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.
> 
> This tree is partially included in linux-next.  To see which patches are
> included in linux-next, consult the `series' file.  Only the patches
> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> linux-next.
> 
> A git tree which contains the memory management portion of this tree is
> maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> by Michal Hocko.  It contains the patches which are between the
> "#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
> file, http://www.ozlabs.org/~akpm/mmotm/series.


on 10 i386 builds, I see around 800 build errors like these:

arc_ps2.c:(.text+0x500): multiple definition of `input_led_connect'
arc_ps2.c:(.text+0x510): multiple definition of `input_led_disconnect'
twl4030-irq.c:(.text+0x3d0): multiple definition of `input_led_connect'
twl4030-irq.c:(.text+0x3e0): multiple definition of `input_led_disconnect'
twl6030-irq.c:(.text+0x0): multiple definition of `input_led_connect'
twl6030-irq.c:(.text+0x10): multiple definition of `input_led_disconnect'
twl4030-madc.c:(.text+0xaa0): multiple definition of `input_led_connect'
twl4030-madc.c:(.text+0xab0): multiple definition of `input_led_disconnect'
da9052-irq.c:(.text+0x20): multiple definition of `input_led_connect'
da9052-irq.c:(.text+0x30): multiple definition of `input_led_disconnect'
da9052-core.c:(.text+0x80): multiple definition of `input_led_connect'
da9052-core.c:(.text+0x90): multiple definition of `input_led_disconnect'
da9052-i2c.c:(.text+0x1b0): multiple definition of `input_led_connect'
da9052-i2c.c:(.text+0x1c0): multiple definition of `input_led_disconnect'
(.text+0x60): multiple definition of `input_led_connect'
(.text+0x70): multiple definition of `input_led_disconnect'
ozusbsvc1.c:(.text+0x110): multiple definition of `input_led_connect'
ozusbsvc1.c:(.text+0x120): multiple definition of `input_led_disconnect'
(.text+0xe3f0): multiple definition of `input_led_connect'
(.text+0xe400): multiple definition of `input_led_disconnect'
(.text+0x12eb10): multiple definition of `input_led_connect'
(.text+0x12eb20): multiple definition of `input_led_disconnect'
(.text+0x5f2c0): multiple definition of `input_led_connect'
(.text+0x5f2d0): multiple definition of `input_led_disconnect'
(.text+0x98b0): multiple definition of `input_led_connect'
(.text+0x98c0): multiple definition of `input_led_disconnect'
(.text+0x26f20): multiple definition of `input_led_connect'
(.text+0x26f30): multiple definition of `input_led_disconnect'
(.text+0x2850): multiple definition of `input_led_connect'
(.text+0x2860): multiple definition of `input_led_disconnect'


I suspect input-route-kbd-leds-through-the-generic-leds-layer.patch
but I'm not sure of it.



-- 
~Randy
