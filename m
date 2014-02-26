Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaBZNRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:17:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaBZNRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:17:03 -0500
Date: Wed, 26 Feb 2014 14:16:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ben Segall <bsegall@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
Message-ID: <20140226131658.GA30956@twins.programming.kicks-ass.net>
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
 <20140225205253.GB18404@twins.programming.kicks-ass.net>
 <530DCDC5.1060406@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530DCDC5.1060406@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:19:33AM +0000, Dietmar Eggemann wrote:
> I changed the patch accordingly.

Thanks!
