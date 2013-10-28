Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3J1WiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:38:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:51284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3J1WiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:38:11 -0400
Date: Mon, 28 Oct 2013 23:38:09 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.10.17-rt12
Message-ID: <20131028223808.GA8631@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.10.17-rt12 patch set.

This is only a stable update (which fixed the livelock in sem_lock()).

Known issues:

      - SLAB support not working

      - The cpsw network driver shows some issues.

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The RT patch against 3.10.17 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.17-rt12.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.17-rt12.tar.xz

Sebastian
