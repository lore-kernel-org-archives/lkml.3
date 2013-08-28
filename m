Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3H1FfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:35:03 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:54023 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3H1FfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:35:01 -0400
Message-ID: <521D8BF9.7070704@t-online.de>
Date: Wed, 28 Aug 2013 07:34:49 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [REGRESSION 3.11-rc] wm8775 9-001b: I2C: cannot write ??? to
 register R??
References: <521A269D.3020909@t-online.de> <521C5493.1050407@cisco.com> <521C72FF.5070902@t-online.de> <521C7697.6070809@cisco.com>
In-Reply-To: <521C7697.6070809@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EAQTyrZTYh-o8YSfI-Zxkh5esL0lktbb8HDz0pv5b8oWjGW2+gRnuPuCqKLN9ZsQFM
X-TOI-MSGID: cfa86899-148b-4ad3-a3c3-776cc78e756a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2013 11:51, Hans Verkuil wrote:
> On 08/27/2013 11:35 AM, Knut Petersen wrote:
>> On 27.08.2013 09:26, Hans Verkuil wrote:
>>> On 08/25/2013 05:45 PM, Knut Petersen wrote:
>>>> Booting current git kernel dmesg shows a set of new  warnings:
>>>>
>>>>       "wm8775 9-001b: I2C: cannot write ??? to register R??"
>>>>
>>>> Nevertheless, the hardware seems to work fine.
>>>>
>>>> This is a new problem, introduced after kernel 3.10.
>>>> If necessary I can bisect.
>>> Can you try this patch? I'm pretty sure this will fix it.
>> Indeed, it does cure the problem. Thanks.
>>
>> Tested-by: Knut Petersen <Knut_Petersen@t-online.de>
> Thanks for testing this! I've posted the pull request for this.
> Hopefully it will make 3.11 before it is released.

As I wrote in the initial bug report, the problem has been introduced _after_ kernel 3.10,
facd23664f1d63c33fbc6da52261c8548ed3fbd4 is _not_ part of kernel 3.10.x

Therefore the CC to stable@vger.kernel.org for v3.10 in
b9a1dfd3ba3ae00b0c1d1a396ed43fac85a32990 is wrong.

cu,
  Knut
> Regards,
>
> 	Hans
>
>

