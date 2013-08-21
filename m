Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3HUP7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:59:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:37631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3HUP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:59:46 -0400
Date: Wed, 21 Aug 2013 17:59:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH RT 0/3] hwlat-detector: Have it actually find hardware
 latency
Message-ID: <20130821155945.GC16913@linutronix.de>
References: <20130819213324.405942342@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130819213324.405942342@goodmis.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-08-19 17:33:24 [-0400]:

>Thi patch series fixes up hwlat-detector to check the entire path
>of time for a latency being hit, instead of the quick check between
>two time stamps.
>
>It also uses the trace_local_clock() if available, which is much lighter
>weight than ktime_get() which might produce false positives. As
>the trace clock is used to detect irq latencies, it's suitable for
>hardware latency.
>
>Finally, stop machine is removed and the test is run by a single thread.

Applied, thanks.

Sebastian
