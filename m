Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaAXMmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:42:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:54201 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:42:23 -0500
Date: Fri, 24 Jan 2014 13:42:16 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, linux-rt-users@vger.kernel.org,
        Andreas Platschek <platschek@ict.tuwien.ac.at>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] read_lock migrate_disable pushdown to rt_read_lock
Message-ID: <20140124124216.GB10264@linutronix.de>
References: <20131205234449.GF15603@opentech.at>
 <20131205211951.5c2eaa0f@gandalf.local.home>
 <20131206023334.GA26623@opentech.at>
 <20131206102532.712d4ae4@gandalf.local.home>
 <20131215151511.GI31090@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131215151511.GI31090@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2013-12-15 16:15:11 [+0100]:

>* Steven Rostedt | 2013-12-06 10:25:32 [-0500]:
>
>>
>>Let me analyze the original code first. I'll poke peterz and tglx too
>>to make sure this modification is OK.
>
>I took 1/3. I postpone the remaining two until I hear something from
>you.

Any news?

Sebastian
