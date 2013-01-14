Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3ANI1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:27:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44593 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3ANI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:27:46 -0500
X-AuditID: 9c930197-b7cefae0000002d7-8d-50f3c17e984d
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/2] sched: simplify select_task_rq_fair() with schedule balance map
References: <50EFCA29.8020801@linux.vnet.ibm.com>
	<50EFCAD9.5020402@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 17:27:41 +0900
In-Reply-To: <50EFCAD9.5020402@linux.vnet.ibm.com> (Michael Wang's message of
	"Fri, 11 Jan 2013 16:18:33 +0800")
Message-ID: <87hamknp8i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 16:18:33 +0800, Michael Wang wrote:
> +next_sd:
> +		if (!sd->level)
> +			break;
> +
> +		sbm = cpu_rq(cpu)->sbm;
> +		if (!sbm)
> +			break;
> +
> +		sd = sbm->sd[type][sd->level - 1];
> +	};

An unnessary semicolone here.

Thanks,
Namhyung
