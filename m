Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaDNG7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:59:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35321 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbaDNG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:59:17 -0400
X-IronPort-AV: E=Sophos;i="4.97,854,1389715200"; 
   d="scan'208";a="29218504"
Message-ID: <534B8820.7090906@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 15:02:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com> <5335661E.7030408@cn.fujitsu.com> <53397E6F.6050600@cn.fujitsu.com> <20140331200209.GD28901@mtj.dyndns.org>
In-Reply-To: <20140331200209.GD28901@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 04:06 AM, Tejun Heo wrote:
> On Mon, Mar 31, 2014 at 10:40:47PM +0800, Lai Jiangshan wrote:
>> Ping
> 
> Lai, I'll keep the mail tagged but can you pleaes ping me once -rc1
> drops?  While it is an actual bug, given that it'd be pretty difficult
> to trigger, I don't think it's too urgent.
> 
> Thanks!
> 

Hi, Tejun
Ping.

Very old (resent) patch(1 patch):
workqueue: add __WQ_FREEZING and remove POOL_FREEZING

Possible race condition patch(1 patch), (In this email thread)
workqueue: fix possible race condition when rescuer VS pwq-release

Worker management patchset(6 patches)
workqueue: simpler&better workers management synchronization
  workqueue: generic routine to restore percpu/unbound pools' workers'
    cpumask
  workqueue: generic framework to manage normal&rescuer workers'
    cpumask
  workqueue: make destroy_worker() atomically
  workqueue: commit worker to pool's concurrency setting atomically.
  workqueue: remove manager_mutex
  workqueue: destroy worker directly in idle timeout handler

Sorry for adding some work to you.

Thanks
Lai
