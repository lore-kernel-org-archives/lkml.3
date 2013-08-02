Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3HBKVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:21:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3HBKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:20:58 -0400
Date: Fri, 2 Aug 2013 12:20:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: =?utf-8?B?77+977+977+92Lzvv70=?= <iamjoonsoo.kim@lge.com>
Cc: "'Preeti U Murthy'" <preeti@linux.vnet.ibm.com>,
        "'Ingo Molnar'" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "'Mike Galbraith'" <efault@gmx.de>, "'Paul Turner'" <pjt@google.com>,
        "'Alex Shi'" <alex.shi@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Morten Rasmussen'" <morten.rasmussen@arm.com>,
        "'Namhyung Kim'" <namhyung@kernel.org>,
        "'Joonsoo Kim'" <js1304@gmail.com>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130802102040.GK27162@twins.programming.kicks-ass.net>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
 <51FB341B.7060104@linux.vnet.ibm.com>
 <001601ce8f5f$7cbe1460$763a3d20$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001601ce8f5f$7cbe1460$763a3d20$@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:05:51PM +0900, ���ؼ� wrote:

What is with you people; have you never learned to trim emails?

Seriously, I'm going to write a script which tests to too many quoted
lines, too many nested quotes and other such nonsense and drop your
emails into /dev/null.

*shees*
