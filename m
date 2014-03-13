Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaCMKfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40323 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358AbaCMKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:35:06 -0400
Message-ID: <532189D7.5010007@free-electrons.com>
Date: Thu, 13 Mar 2014 11:35:03 +0100
From: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: zmxu@marvell.com, jszhang@marvell.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] ARM: add initial support for the Marvell BG2-Q DMP
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <20140312113523.GL13905@piout.net> <53217FA1.4020903@gmail.com>
In-Reply-To: <53217FA1.4020903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 13/03/2014 10:51, Sebastian Hesselbarth wrote:
> On 03/12/2014 11:35 AM, Alexandre Belloni wrote:
>> On 12/03/2014 at 12:06:02 +0100, Antoine Ténart wrote :
>>> This serie adds the initial support for the Marvell BG2-Q DMP (part
>>> of the
>>> Berlin family). SoC has nodes for cpu, l2 cache controller, interrupt
>>> controllers, local timer, apb timers and uarts for now.
>>>
>>> Homepage: http://www.marvell.com/digital-entertainment/armada-1500-pro/
>>>
>>
>> I would move that description to the commit logs. Else one would have to
>> lookup the mailing list archive to read it.
>
> Antoine,
>
> thanks for posting this. I also prefer each patch to have a commit log
> no matter how obvious the contents may be. Please have a simple commit
> log for each of the single patches.
>
> You can leave out the link to marvell.com in the commit log as you
> update Marvell SoC documentation.

I'll cook up a v2 today. Thanks for the feedback !

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
