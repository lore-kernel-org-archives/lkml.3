Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbbAIOiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:38:22 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40811 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAIOiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:38:20 -0500
MIME-Version: 1.0
In-Reply-To: <87387kjbjo.fsf@kamboji.qca.qualcomm.com>
References: <1419766622-10911-1-git-send-email-oscar.forner.martinez@gmail.com>
	<87bnmaqxvs.fsf@kamboji.qca.qualcomm.com>
	<CACna6rzWaHg=M15q=swf+yqMEB3smRRANuLHkSK1dU1MtG8jgg@mail.gmail.com>
	<87y4peo2of.fsf@kamboji.qca.qualcomm.com>
	<CACna6rzdtx2pBHE-00uocUEqNrbopShUW83R0dYeQBD26eC=NA@mail.gmail.com>
	<87387kjbjo.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 9 Jan 2015 15:38:19 +0100
Message-ID: <CACna6rz6xGLKxVHMka-PTOM0ybi_fbu1-AtUqF9jU2aFHZRODQ@mail.gmail.com>
Subject: Re: [PATCH v4] bcma: fix two coding style issues, more than 80
 characters per line.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2015 at 15:03, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> On 7 January 2015 at 19:39, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Rafał Miłecki <zajec5@gmail.com> writes:
>>>
>>>> On 7 January 2015 at 18:55, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>> Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:
>>>>>
>>>>>> Two lines with more than 80 characters per line have been split in several lines.
>>>>>>
>>>>>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>>>>>
>>>>> Thanks, applied to wireless-drivers-next.git.
>>>>
>>>> Could you still replace it (V4) with an older version (V3)? Before I
>>>> explained V3 was OK Oscar already sent this (worse) V4.
>>>
>>> No. I'm not going to rebase a public git tree unless there's a huge
>>> disaster.
>>
>> I was pretty sure you didn't push it yet, that's why I asked.
>
> Heh, we got lucky. So I had actually run 'git push' but missed that the
> authenticate had failed. A good thing you pointed out this. So I know
> dropped this patch from my tree and pushed rest of the patches I had
> applied.
>
> Rafal, is this the patch I should apply:
>
> https://patchwork.kernel.org/patch/5545021/
>
> Please confirm.

That's correct.

-- 
Rafał
