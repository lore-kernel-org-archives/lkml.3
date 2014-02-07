Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaBGT7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:59:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:48259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBGT7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:59:08 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: A pile of sched patches
Date: Fri,  7 Feb 2014 20:58:36 +0100
Message-Id: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.rc1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were sitting -RT for quite some time. I think they sneaked
in during the v3.10 time frame.
Three are of them fix bugs and are marked for stable. The other three
improve might_sleep() debuging / output.

Sebastian

