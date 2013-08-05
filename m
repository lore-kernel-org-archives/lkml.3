Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3HEHWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:22:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58189 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3HEHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:22:22 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-84-51ff52acaba4
Date: Mon, 5 Aug 2013 16:22:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "'Preeti U Murthy'" <preeti@linux.vnet.ibm.com>,
        "'Ingo Molnar'" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "'Mike Galbraith'" <efault@gmx.de>, "'Paul Turner'" <pjt@google.com>,
        "'Alex Shi'" <alex.shi@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Morten Rasmussen'" <morten.rasmussen@arm.com>,
        "'Namhyung Kim'" <namhyung@kernel.org>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130805072230.GB27240@lge.com>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
 <51FB341B.7060104@linux.vnet.ibm.com>
 <001601ce8f5f$7cbe1460$763a3d20$@lge.com>
 <20130802102040.GK27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130802102040.GK27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:20:40PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 02, 2013 at 06:05:51PM +0900, ���ؼ� wrote:
> 
> What is with you people; have you never learned to trim emails?
> 
> Seriously, I'm going to write a script which tests to too many quoted
> lines, too many nested quotes and other such nonsense and drop your
> emails into /dev/null.

Hello, Peter.

Sorry about that.
I will be careful about this later.

Thanks.
