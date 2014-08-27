Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbaH0Ncw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:32:52 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43083 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625AbaH0Ncs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:32:48 -0400
Date: Wed, 27 Aug 2014 19:02:28 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 06/12] sched: add per rq cpu_capacity_orig
Message-ID: <20140827133033.GC13808@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082713-2000-0000-0000-000001B9D420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Guittot <vincent.guittot@linaro.org> [2014-08-26 13:06:49]:

> This new field cpu_capacity_orig reflects the available capacity of a CPUs
> unlike the cpu_capacity which reflects the current capacity that can be altered
> by frequency and rt tasks.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

