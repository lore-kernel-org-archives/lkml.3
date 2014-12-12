Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbaLLJtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:49:25 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:53740 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934764AbaLLJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:49:22 -0500
Message-ID: <1418377757.5756.24.camel@x220>
Subject: Re: linux-next: Tree for Dec 12
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 10:49:17 +0100
In-Reply-To: <20141212183518.06e3803d@canb.auug.org.au>
References: <20141212183518.06e3803d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2014 09:49:17.0951 (UTC) FILETIME=[E571A8F0:01D015F0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 2014-12-12 at 18:35 +1100, Stephen Rothwell wrote:
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

(Side note: it took me some time to realize that evolution automagically
removes the above lines and the log that follows because it is
considered one humongous signature. Maybe there's a setting to stop
evolution doing that. Anyhow, I copied the quotes in this message by
hand.)

> $ git checkout master
> $ git reset --hard stable
> [...]
> Merging akpm-current/current (35ac317b788c shmdt: use i_size_read() instead of ->i_size)
> CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
> CONFLICT (content): Merge conflict in mm/page_alloc.c
> CONFLICT (content): Merge conflict in mm/memcontrol.c
> CONFLICT (content): Merge conflict in mm/hugetlb.c
> CONFLICT (content): Merge conflict in kernel/printk/printk.c
> CONFLICT (content): Merge conflict in kernel/exit.c
> CONFLICT (content): Merge conflict in init/main.c

I think the conflict resolution here can be found in your merge commit
bcab756e1d32 ("Merge branch 'akpm-current/current'").

For some reason it removes the only check for CONFIG_INIT_FALLBACK. I
only noticed because that makes the Kconfig entry INIT_FALLBACK a nop.
That check and Kconfig entry were added in commit 6ef4536e2f19 ("init:
allow CONFIG_INIT_FALLBACK=n to disable defaults if init= fails"). That
commit debuted in today's linux-next.

Anyhow, I'm sure this all will be sorted out in due time.

> CONFLICT (content): Merge conflict in include/linux/mmzone.h
> CONFLICT (content): Merge conflict in fs/proc/task_mmu.c
> CONFLICT (content): Merge conflict in fs/ocfs2/inode.h
> CONFLICT (content): Merge conflict in fs/binfmt_misc.c
> CONFLICT (content): Merge conflict in drivers/usb/storage/debug.c
> CONFLICT (content): Merge conflict in drivers/rtc/rtc-omap.c
> CONFLICT (content): Merge conflict in drivers/rtc/rtc-isl12057.c
> CONFLICT (content): Merge conflict in drivers/rtc/rtc-ds1374.c
> CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/vendor-prefixes.txt
> CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/i2c/trivial-devices.txt

Thanks,


Paul Bolle

