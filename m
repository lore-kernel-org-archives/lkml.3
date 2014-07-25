Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbaGYIXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:23:20 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6348 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859AbaGYIXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:23:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 25 Jul 2014 01:11:19 -0700
Message-ID: <53D213A8.6000506@nvidia.com>
Date: Fri, 25 Jul 2014 13:52:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>,
        "eduardo.valentin@gmail.com" <eduardo.valentin@gmail.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if device
 node missing
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com> <53D0D694.9040101@nvidia.com> <744357E9AAD1214791ACBA4B0B90926301396F53@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301396F53@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rui.
It seems I have put the wrong email-id for Eduardo (which I got from 
get_maintainer) and the original patch not reached to Eduardo.

Do I need to re-post patch?

Thanks,
Laxman

On Thursday 24 July 2014 08:45 PM, Zhang, Rui wrote:
> Hi, Laxman,
>
> As Eduardo is the of thermal author and maintainer, I will take your patch only if you can get ACK from Eduardo.
>
> Eduardo,
> Do you have any comments on this?
>
> Thanks,
> rui
>
>> -----Original Message-----
>> From: Laxman Dewangan [mailto:ldewangan@nvidia.com]
>> Sent: Thursday, July 24, 2014 5:49 PM
>> To: Zhang, Rui; eduardo.valentin@ti.com
>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if
>> device node missing
>> Importance: High
>>
>> On Monday 14 July 2014 04:42 PM, Laxman Dewangan wrote:
>>> There are some mfd devices which supports junction thermal interrupt
>>> like ams,AS3722. The DT binding of these devices are defined as the
>>> flat and drivers for sub module of such devices are registered as the
>>> mfd_add_devices. In this method, the sub devices registered as
>>> platform driver and these do not have the of_node pointer on their
>>> device structure. In this case, use the parent of_node pointer to get
>>> the required of_node pointer.
>>>
>> Any comment please?

