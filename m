Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab3DBKAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:00:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39699 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab3DBKAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:00:17 -0400
Message-ID: <1364896813.18374.0.camel@laptop>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Tue, 02 Apr 2013 12:00:13 +0200
In-Reply-To: <20130402095034.GG16699@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364890206.16858.6.camel@laptop> <20130402095034.GG16699@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 18:50 +0900, Joonsoo Kim wrote:
> 
> It seems that there is some misunderstanding about this patch.
> In this patch, we don't iterate all groups. Instead, we iterate on
> cpus of local sched_group only. So there is no penalty you mentioned.

OK, I'll go stare at it again..

