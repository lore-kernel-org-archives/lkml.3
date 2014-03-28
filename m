Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaC1Jfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:35:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:46932 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaC1Jfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:35:37 -0400
Date: Fri, 28 Mar 2014 10:35:33 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] dont calculate hweight in update_migrate_disable
Message-ID: <20140328093533.GA14842@linutronix.de>
References: <20140324121848.GA18300@opentech.at>
 <20140324101800.3f978842@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140324101800.3f978842@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-03-24 10:18:00 [-0400]:

>On Mon, 24 Mar 2014 13:18:48 +0100
>Nicholas Mc Guire <der.herr@hofr.at> wrote:
>
>> Proposal for a minor optimization in update_migrate_disable - its only a few 
>> instructions saved but those are in the hot path of locks so it might be worth
>> it
>Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Applied.

>
>-- Steve

Sebastian
