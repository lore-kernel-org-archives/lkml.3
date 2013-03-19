Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3CSM7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:59:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54402
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421Ab3CSM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:59:41 -0400
Message-ID: <1363697977.22553.44.camel@laptop>
Subject: Re: [PATCH 1/8] sched: change position of resched_cpu() in
 load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 13:59:37 +0100
In-Reply-To: <1360820921-2513-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> cur_ld_moved is reset if env.flags hit LBF_NEED_BREAK.
> So, there is possibility that we miss doing resched_cpu().
> Correct it as changing position of resched_cpu()
> before checking LBF_NEED_BREAK.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

