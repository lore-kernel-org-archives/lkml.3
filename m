Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaA3AMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:12:15 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:61500 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaA3AMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX6CiumfOi2cgU1ODrKuaTHCZxo3zNmW01kn+GT1CAT3w@mail.gmail.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
	<CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
	<CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
	<CAE9FiQX6CiumfOi2cgU1ODrKuaTHCZxo3zNmW01kn+GT1CAT3w@mail.gmail.com>
Date: Wed, 29 Jan 2014 16:12:13 -0800
Message-ID: <CA+8MBbLggLtM6ZQhmS0qZQaRG0b+HxtawxXSu5bUzHS-rMVcYg@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Tony Luck <tony.luck@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying on top of Linus' tree (commit =
dda68a8c1707b4011dc3c656fa1b2c6de6f7f304) I just get:

patching file include/linux/bootmem.h
Hunk #1 FAILED at 264.
Hunk #2 FAILED at 272.
2 out of 2 hunks FAILED -- saving rejects to file include/linux/bootmem.h.rej

- not a promising start :-(

-Tony
