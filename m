Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaAaU2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:56401 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbaAaU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:28:16 -0500
Date: Fri, 31 Jan 2014 21:28:14 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org,
        Sami Pietikainen <Sami.Pietikainen@wapice.com>,
        Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] API cleanup - use local_lock not __local_lock for soft
Message-ID: <20140131202814.GC21238@linutronix.de>
References: <20131229171154.GA23586@opentech.at>
 <20140117144729.GB5785@linutronix.de>
 <20140117145955.GA5637@opentech.at>
 <52D94891.80109@linutronix.de>
 <20140117153323.GA23566@opentech.at>
 <20140117113218.7392363d@gandalf.local.home>
 <20140117194403.GC20157@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140117194403.GC20157@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-01-17 20:44:03 [+0100]:

>
>trivial API cleanup - kernel/softirq.c was mimiking local_lock. 

Applied

Sebastian
