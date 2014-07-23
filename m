Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaGWBZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:25:40 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29799 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753477AbaGWBZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:25:38 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33656660"
Message-ID: <53CF0F46.8000508@cn.fujitsu.com>
Date: Wed, 23 Jul 2014 09:26:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: get the probable node ID from the first CPU
 of the mask
References: <1406005442-12070-1-git-send-email-laijs@cn.fujitsu.com> <20140722153023.GF13851@htj.dyndns.org>
In-Reply-To: <20140722153023.GF13851@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 11:30 PM, Tejun Heo wrote:
> On Tue, Jul 22, 2014 at 01:04:02PM +0800, Lai Jiangshan wrote:
>> +		node = cpu_to_node(cpumask_first(pool->attrs->cpumask));
> 
> Minor but maybe cpumask_any() is a better fit here?
> 

It is OK, the result are the same. But I still think cpumask_first() is better since
its name sounds deterministic while we need a deterministic value for pool->node.

Thanks,
Lai
