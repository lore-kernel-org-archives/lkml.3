Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3EMJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:01:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40928 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3EMJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:01:19 -0400
Date: Mon, 13 May 2013 10:59:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] sched: Add nr_running_cpu() to get current of running
 threads of each core
Message-ID: <20130513085935.GA3708@dyad.programming.kicks-ass.net>
References: <1368433992-19162-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368433992-19162-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:33:12PM +0900, Chanwoo Choi wrote:
> This patch add nr_running_cpu() function to get current
> number of running threads of each core.
> 

Uhm, not without a very good reason. 
