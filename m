Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936725Ab3DHP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:57:18 -0400
Received: from www.sr71.net ([198.145.64.142]:41396 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761509Ab3DHP5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:57:16 -0400
Message-ID: <5162E8DC.4080204@sr71.net>
Date: Mon, 08 Apr 2013 08:57:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
References: <515DBB00.20208@sr71.net> <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
In-Reply-To: <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 04:41 PM, Frederic Weisbecker wrote:
> Does this patch fix the issue for you?
> https://lkml.org/lkml/2013/4/4/112

Nope, that doesn't seem to make a difference.  I'm still seeing the
underflow.  I'm pretty sure it's already gone to hell by the time it
gets in to the loop that's patched there.


