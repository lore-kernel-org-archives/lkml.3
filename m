Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3IBGgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:36:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42096 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3IBGgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:36:23 -0400
Date: Mon, 2 Sep 2013 12:06:05 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        efault@gmx.de, pjt@google.com, preeti@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        aswin@hp.com, scott.norton@hp.com
Subject: Re: [PATCH v4 1/3] sched: Reduce overestimating rq->avg_idle
Message-ID: <20130902063605.GU1720@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-2-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1377806736-3752-2-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090206-7164-0000-0000-000001329266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Low <jason.low2@hp.com> [2013-08-29 13:05:34]:

> When updating avg_idle, if the delta exceeds some max value, then avg_idle
> gets set to the max, regardless of what the previous avg was. This can cause
> avg_idle to often be overestimated.
> 
> This patch modifies the way we update avg_idle by always updating it with the
> function call to update_avg() first. Then, if avg_idle exceeds the max, we set
> it to the max.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---

