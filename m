Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab3BMQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:13:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:59761 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403Ab3BMQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:57 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Subject: [PREEMPT RT] SLUB and split softirq lock for v3.4-rt
Date: Wed, 13 Feb 2013 17:13:39 +0100
Message-Id: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-rt which lacks two RT features from 3.6: SLUB support and the
split softirq lock implementation.

SLUB has a way better performance than SLAB on RT and the split
softirq lock implementation is necessary especially for realtime
networking applications.

The following patch series backports these features to 3.4-rt.

Steven, could you please apply these patches to a separate
3.4-rt-features branch?

Sebastian
