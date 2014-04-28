Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaD1N0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:26:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37027 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbaD1N0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:26:06 -0400
Message-ID: <535E56E3.6070004@linaro.org>
Date: Mon, 28 Apr 2014 21:25:55 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        "naresh.kamboju@linaro.org Kamboju" <naresh.kamboju@linaro.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: deadlock in ipv6?
References: <535A0950.9090302@linaro.org> <20140425073325.GA7050@order.stressinduktion.org>
In-Reply-To: <20140425073325.GA7050@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:33 PM, Hannes Frederic Sowa wrote:
> On Fri, Apr 25, 2014 at 03:05:52PM +0800, Alex Shi wrote:
>> [   18.624755]        CPU0
>>
>> [   18.627349]        ----
>>
>> [   18.629943]   lock(&addrconf_stats->syncp.seq);
>>
>> [   18.634735]   <Interrupt>
>>
>> [   18.637512]     lock(&addrconf_stats->syncp.seq);
>>
> 
> Stable kernel should already carry a fix for this, 43a43b6040165f7
> ("ipv6: some ipv6 statistic counters failed to disable bh"). Could you give it
> a try?
> 

It seems a right fix. Thanks a lot for notification!

> Bye,
> 
>   Hannes
> 


-- 
Thanks
    Alex
