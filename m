Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBLOy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:54:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBLOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:54:56 -0500
Date: Wed, 12 Feb 2014 15:54:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [tip:sched/core] sched: Push put_prev_task() into
 pick_next_task( )
Message-ID: <20140212145447.GY27965@twins.programming.kicks-ass.net>
References: <1328936700.2476.17.camel@laptop>
 <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
 <124891392188453@web4h.yandex.ru>
 <20140212140620.GD9987@twins.programming.kicks-ass.net>
 <364441392215058@web18m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <364441392215058@web18m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:24:18PM +0400, Kirill Tkhai wrote:
> Maybe pack prev->sched_class->put_prev_task() into inline function?

Good suggestion, done.
