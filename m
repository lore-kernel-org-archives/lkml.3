Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaIZJaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:30:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:38733 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaIZJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:30:03 -0400
Date: Fri, 26 Sep 2014 11:29:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@kernel.org>
cc: Lina Iyer <lina.iyer@linaro.org>, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
In-Reply-To: <7htx3vbfqr.fsf@deeprootsystems.com>
Message-ID: <alpine.DEB.2.11.1409261129220.4567@nanos>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org> <1409170479-29955-4-git-send-email-lina.iyer@linaro.org> <alpine.DEB.2.10.1408272239190.3323@nanos> <20140902184305.GB91995@ilina-mac.local> <alpine.DEB.2.10.1409022109050.3333@nanos>
 <7htx3vbfqr.fsf@deeprootsystems.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Kevin Hilman wrote:
> Maybe I'm missing something, or maybe we're just lucky and nobody uses
> them together, but irq_set_affinity_notifier() only allows a single
> notifier to be registered at any given time.  So if you had a system

A single notifier per irq .....
