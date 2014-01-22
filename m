Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaAVSG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:06:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36509 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:06:55 -0500
Date: Wed, 22 Jan 2014 19:06:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
Message-ID: <20140122180635.GX13532@twins.programming.kicks-ass.net>
References: <20140121111754.580142558@infradead.org>
 <20140121112258.708117448@infradead.org>
 <xm2661pdkuiw.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140121193759.GR11314@laptop.programming.kicks-ass.net>
 <xm261u01kspx.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140121204312.GS11314@laptop.programming.kicks-ass.net>
 <xm26wqhtj9iz.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26wqhtj9iz.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 01:43:32PM -0800, bsegall@google.com wrote:
> prev can be NULL to start with, hrtick should be handled in both paths.
> How about this on top of your patch (equally untested) to fix those and
> the XXX? The double-check on nr_running is annoying, but necessary when
> prev slept.

Ah yes indeed. Let me build the lot and see if I can wreck it ;-)
