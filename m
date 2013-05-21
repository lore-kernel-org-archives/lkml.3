Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3EUU06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:26:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:52859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EUU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:26:57 -0400
Date: Tue, 21 May 2013 22:26:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org
Subject: [ANNOUNCE] 3.8.13-rt9
Message-ID: <20130521202656.GA3374@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt9 release.

This release is just an update to the new stable 3.8.13 version
and no RT specific changes have been made.

Known issues:

    - SLxB is broken on PowerPC, e500 based cpus. Can't repdroduce the
      problem on mpc5200 based board.

The RT patch against 3.8.13 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt9.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt9.tar.xz

Sebastian
