Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbaGRD7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:59:08 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:57684 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903AbaGRD7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:59:06 -0400
X-Spam-Flag: NO
Message-ID: <53C89AC1.8040606@pavlinux.ru>
Date: Fri, 18 Jul 2014 07:55:45 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rolf Peukert <rolf.peukert@imms.de>, Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT 0/4] Linux 3.2.60-rt89-rc1
References: <20140714200634.590977709@goodmis.org> <53C4623F.5090901@pavlinux.ru> <53C653BC.5020708@imms.de>
In-Reply-To: <53C653BC.5020708@imms.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.07.2014 14:28, Rolf Peukert пишет:
> On 15.07.2014 01:05, Pavel Vasilyev wrote:
>> 15.07.2014 00:06, Steven Rostedt пишет:
>>> Dear RT Folks,
>>>
>>> This is the RT stable review cycle of patch 3.2.60-rt89-rc1.
>>
>> Actually 3.2.61
>>
>> kernel/irq/manage.c
>> kernel/rtmutex.c
>>
>> This files FUZZED :(
>
> Just for the record, the (incremental) patch applies and runs without
> problems on an 3.2.60-rt88 (built for ARM).
>

I'm about 3.2.61


-- 

                                                          Pavel.
