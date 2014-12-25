Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaLYDeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 22:34:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39479 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLYDeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 22:34:09 -0500
Message-ID: <549B857F.8020806@gmail.com>
Date: Thu, 25 Dec 2014 09:03:19 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Chen <peter.chen@freescale.com>
CC: Stefan Agner <stefan@agner.ch>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: chipidea: Add identification registers access
 APIs
References: <cover.1418981438.git.maitysanchayan@gmail.com> <72124df17c0f40f8a7ae02faa9664b9d51743584.1418981438.git.maitysanchayan@gmail.com> <4f5efe169ed3ab16ffcbee52dd6b7661@agner.ch> <549AE6A3.3060009@gmail.com> <20141225021355.GB5077@shlinux2>
In-Reply-To: <20141225021355.GB5077@shlinux2>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2014 07:43 AM, Peter Chen wrote:
> On Wed, Dec 24, 2014 at 09:45:31PM +0530, Sanchayan Maity wrote:
>> On 12/24/2014 09:30 PM, Stefan Agner wrote:
>>> On 2014-12-19 10:55, Sanchayan Maity wrote:
>>>> Using hw_write_id_reg and hw_read_id_reg to write and read
>>>> identification registers contents. This can be used to get
>>>> controller information, change some system configurations
>>>> and so on.
>>>
>>> Checkpatch is complaining about DOS line endings and some trailing
>>> whitespace. This applies to all three patches.
>>
>> Hmm... that's surprising. I did run checkpatch at my end before sending.
>> I do not have the original patchset on my laptop which I have right now
>> but downloading diffs back from lkml and running checkpatch on them back,
>> only gives me signed off errors as it should. 
>>
>> I will resend if somehow errors crept in with my earlier patches.
>>
>> -Sanchayan
>>
> 
> Hi Sanchayan,
> 
> I will take care the first two, you are the third if there is any
> comments, thanks.
> 
Hi Peter,

OK with me. I can resend all the three patches with Stefan's recommended changes
if you did like.

-Regards,
Sanchayan.
