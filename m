Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaK1E1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:27:37 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53661 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK1E1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:27:35 -0500
Message-ID: <5477F9B1.2060704@gmail.com>
Date: Fri, 28 Nov 2014 09:57:29 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: a.zummo@towertech.it
CC: Shawn Guo <shawn.guo@linaro.org>, Stefan Agner <stefan@agner.ch>,
        rtc-linux@googlegroups.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 3/3] drivers/rtc/rtc-snvs: Add clock support
References: <cover.1415364391.git.maitysanchayan@gmail.com> <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com> <7807253ec0fd349b5bb1489e0d3b1347@agner.ch> <546320D3.2030501@gmail.com> <20141112104735.GK2704@dragon> <54644295.2050003@gmail.com> <20141119011721.GA24042@dragon> <546C2164.3040708@gmail.com>
In-Reply-To: <546C2164.3040708@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 10:19 AM, Sanchayan Maity wrote:
> On Wednesday 19 November 2014 06:47 AM, Shawn Guo wrote:
>> On Thu, Nov 13, 2014 at 11:03:09AM +0530, Sanchayan Maity wrote:
>>> On Wednesday 12 November 2014 04:17 PM, Shawn Guo wrote:
>>>> On Wed, Nov 12, 2014 at 02:26:51PM +0530, Sanchayan Maity wrote:
>>>>> On Wednesday 12 November 2014 02:57 AM, Stefan Agner wrote:
>>>>>> On 2014-11-07 14:04, Sanchayan Maity wrote:
>>>>>>> This patch adds clock enable and disable support for
>>>>>>> the SNVS peripheral, which is required for using the
>>>>>>> RTC within the SNVS block.
>>>>>>
>>>>>> What happens if the device tree node is there while this patch is not
>>>>>> applied? I guess the driver would load, but since the clocks of the
>>>>>> peripheral are not enabled the first register access would lead to bus
>>>>>> error or similar. If this is the case, this would break bisectability.
>>>>>> You should move the device tree patch to the end.
>>>>>>
>>>>>
>>>>> If the DT node was present with this patch not applied, the driver would 
>>>>> still crash with a bus error, since the clocks for SNVS are not explicitly 
>>>>> enabled anywhere else. I had not thought about any problems which might 
>>>>> occur later with git bisect. Will move this to the end with v3.
>>>>
>>>> Since changes on rtc-snvs.c will need to go through RTC subsystem tree,
>>>> that means I cannot apply DTS changes until the driver patch gets
>>>> mainlined and appears on my tree.
>>>>
>>>> Shawn
>>>
>>> Shawn
>>>
>>> So the approach in this patch is OK and acceptable? 
>>
>> Yes, I'm fine with it.
>>
>> Shawn
> 
> 
> Hello Alessandro, 
> 
> Sorry I missed adding you while sending this patch set.
> 
> Can you take this third patch, in this series through your RTC subsytem
> tree? Or should I resend this third patch separately?

Ping? Any inputs? Should I resend or is this Ok?
> 
> Regards,
> Sanchayan.
> 
>>
>>>
>>> Since the DT changes cannot be applied by you, till this goes through the 
>>> RTC subsystem tree, gets mainlined and appears on your tree, I will send out 
>>> this patch by itself then and send the DT changes later once this gets
>>> mainlined?
>>>
>>> I did not CC Alessandro Zummo, the maintainer of RTC subsystem by mistake.
>>> Once you ACK/OK this i will send out this patch in isolation then or just 
>>> CC Alessandro Zummo.
