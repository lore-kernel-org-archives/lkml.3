Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaELWBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:01:07 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:54799 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaELWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:01:05 -0400
Date: Mon, 12 May 2014 18:01:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 08/10 V2] workqueue: rename manager_mutex to attach_mutex
Message-ID: <20140512220102.GH18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-9-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-9-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:20PM +0800, Lai Jiangshan wrote:
> manager_mutex is only used to protect the attaching for the pool
> and the pool->workers list. It protects the pool->workers and operations
> based on this list, such as:
> 	cpu-binding for the workers in the pool->workers
> 	concurrency management for the workers in the pool->workers

Concurrency management?  What are you referring to?

thanks.

-- 
tejun
