Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaCGQAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:00:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:38522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaCGQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:00:04 -0500
Date: Fri, 7 Mar 2014 17:00:02 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: [patch] rt,blk,mq: Make blk_mq_cpu_notify_lock a raw spinlock
Message-ID: <20140307160002.GB18441@linutronix.de>
References: <1393822646.5816.4.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1393822646.5816.4.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-03-03 05:57:26 [+0100]:

> block/blk-mq-cpu.c |   14 +++++++-------

This got in v3.13-rc1, are you running some kind of backported version
of this in v3.12 or do you have your own v3.13-rt?

Sebastian
