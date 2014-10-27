Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaJ0JYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:24:19 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42010 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808AbaJ0JYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:24:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,794,1406563200"; 
   d="scan'208";a="42387981"
Message-ID: <544E0FFD.1060006@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 17:27:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] workqueue: unbound workqueue management Vs hotplug
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 10/08/2014 11:53 AM, Lai Jiangshan wrote:
> Hi, TJ
> 
> These patches are for unbound workqueue management (hotplug).
> 
> This patchset simplify the unbound workqueue management when hotplug.
> This is also a preparation patchset for later unbound workqueue management
> patches.
> 
> Thanks,
> Lai.
> 
> Lai Jiangshan (3):
>   workqueue: add wq_unbound_online_cpumask
>   workqueue: extend wq_pool_mutex to also protect pwq-installation
>   workqueue: remove get_online_cpus() from apply_workqueue_attrs()
> 
>  kernel/workqueue.c |   61 ++++++++++++++++++++-------------------------------
>  1 files changed, 24 insertions(+), 37 deletions(-)
> 

