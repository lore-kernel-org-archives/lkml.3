Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaL1PBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 10:01:13 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:23042 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaL1PBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 10:01:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,655,1413270000"; 
   d="scan'208";a="53817660"
Message-ID: <54A01B34.4000002@broadcom.com>
Date: Sun, 28 Dec 2014 16:01:08 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Sedat Dilek <sedat.dilek@gmail.com>,
        Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80 characters
 per line
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>	<CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>	<CA+icZUVm6YNK_eN7-NcSH-mAqC61vwYryVUJuNMCKuhq8kXV2g@mail.gmail.com>	<CACna6rymPy1+YtEHEk18ci3VaAWkiwJ2iWv+p_yYPAjzQeJwtw@mail.gmail.com>	<CA+icZUVuTB55UcKKbUMd8VB5mHMkaxhCVDkLKhtSXizR+1gE2A@mail.gmail.com> <CACna6rwRPwannK7TviY7AmhMvd09h-zLXJOBEK-U09dz=5ezKQ@mail.gmail.com>
In-Reply-To: <CACna6rwRPwannK7TviY7AmhMvd09h-zLXJOBEK-U09dz=5ezKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/14 15:02, Rafał Miłecki wrote:
> On 28 December 2014 at 10:12, Sedat Dilek<sedat.dilek@gmail.com>  wrote:
>> On Sun, Dec 28, 2014 at 9:53 AM, Rafał Miłecki<zajec5@gmail.com>  wrote:
>>> On 28 December 2014 at 06:50, Sedat Dilek<sedat.dilek@gmail.com>  wrote:
>>>> On Sun, Dec 28, 2014 at 12:44 AM, Rafał Miłecki<zajec5@gmail.com>  wrote:
>>>>> On 27 December 2014 at 20:24, Oscar Forner Martinez
>>>>> <oscar.forner.martinez@gmail.com>  wrote:
>>>>>> Three lines with more than 80 characters per line have been split in several lines.
>>>>>>
>>>>>> Signed-off-by: Oscar Forner Martinez<oscar.forner.martinez@gmail.com>
>>>>>
>>>>> Acked-by: Rafał Miłecki<zajec5@gmail.com>
>>>>>
>>>>
>>>> As for the comment-line changes... 80+ chars are allowed for better readability.
>>>> So, please don't do that.
>>>> [ Checkpatch should not warn on this especially for comments. ]
>>>
>>> We almost always split long comments into separated lines in the
>>> kernel. What's different with this case?
>>>
>>
>> 1st it is not mandatory.
>>
>> 2nd it is more readable in one line.
>>
>> -                       /* 4706 CC and PMU watchdogs are clocked at
>> 1/4 of ALP clock */
>> +                       /* 4706 CC and PMU watchdogs are clocked at 1/4 of ALP
>> +                        * clock
>> +                        */
>>
>> I agree with you when the comment would be longer.
>
> So I guess there is some rule like
> "Don't use 2 lines if there is 80 chars + one word"
> ? Where can I find such rules?

Personally, I don't like taking this sliding slope. Just stick to the 80 
characters rule and add a few words in the comment, eg:

			/* The BCM4706 ChipCommon and PMU watchdogs are
			 * clocked at one quarter of the ALP clock.
			 */

Regards,
Arend

