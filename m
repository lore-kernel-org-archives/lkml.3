Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaETOe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:34:28 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:45359 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbaETOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:34:27 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "bsegall@google.com" <bsegall@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "chris.j.arges@canonical.com" <chris.j.arges@canonical.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20140520142804.GB30445@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
	 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
	 <87lhu215ky.wl%klamm@yandex-team.ru>
	 <20140519103247.GX30445@twins.programming.kicks-ass.net>
	 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
	 <20140520131526.GE11096@twins.programming.kicks-ass.net>
	 <99801400595675@webcorp1f.yandex-team.ru> <20140520142804.GB30445@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
MIME-Version: 1.0
Message-Id: <107621400596463@webcorp2h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 20 May 2014 18:34:23 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have an easy to reproduce setup and workload so I might be able
> to test as well? Or are you simply dumping it in 'production' to see
> what happens?

No. I have only a "production" setup, where I can nicely reproduce all these lockups.
It takes ~1 day. I also tried to reproduce them locally but without any success.

Thanks,
Roman
