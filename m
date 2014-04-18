Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaDRKYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:24:36 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64388 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753123AbaDRKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:24:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29441839"
Message-ID: <5350EF6F.3070905@cn.fujitsu.com>
Date: Fri, 18 Apr 2014 18:25:03 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 17/17] sched: Get rid of opened code implementation of
 funtion nice_to_rlimit().
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com> <220c27487540603b7af88ef327600804212a6706.1394532288.git.yangds.fnst@cn.fujitsu.com> <20140418100111.GA29098@gmail.com> <5350ED15.7070103@cn.fujitsu.com> <20140418101942.GA21711@gmail.com>
In-Reply-To: <20140418101942.GA21711@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 07:19 PM, Ingo Molnar wrote:
> * Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
>
>> On 04/18/2014 07:01 PM, Ingo Molnar wrote:
>>> So the patch title has two typos and a superfluous period.
>> Really sorry for that. :( I will update it right now.
> Please wait for the next -tip update before you resend the series -
> I've applied a handful of other patches from you, which will reduce
> the size of your queue.

Okey, thanx !

>
> Thanks,
>
> 	Ingo
>

