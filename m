Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaIXAsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:48:19 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14450 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbaIXAsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:48:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,584,1406563200"; 
   d="scan'208";a="36364976"
Message-ID: <54221564.4020108@cn.fujitsu.com>
Date: Wed, 24 Sep 2014 08:50:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: show the pool ID of the default pwq's pool
 in the pool_ids file
References: <1411373079-11828-1-git-send-email-laijs@cn.fujitsu.com> <20140923143804.GD19208@htj.dyndns.org>
In-Reply-To: <20140923143804.GD19208@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 10:38 PM, Tejun Heo wrote:
> On Mon, Sep 22, 2014 at 04:04:37PM +0800, Lai Jiangshan wrote:
>> It seems incomplete if the pool_ids file doesn't include the default
>> pwq's pool.  Add it and the result:
>>
>> # cat pool_ids 
>> 0:9 1:10
>> default:8
> 
> Hmmm?  default pwq is used only as the fallback if pool switching
> fails and the failed nodes will have it assigned to them.  Why would
> userland care about something which isn't being used?

Understood.

> 
> Thanks.
> 

