Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbbAGSju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:39:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47020 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbbAGSjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:39:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] bcma: fix two coding style issues, more than 80 characters per line.
References: <1419766622-10911-1-git-send-email-oscar.forner.martinez@gmail.com>
	<87bnmaqxvs.fsf@kamboji.qca.qualcomm.com>
	<CACna6rzWaHg=M15q=swf+yqMEB3smRRANuLHkSK1dU1MtG8jgg@mail.gmail.com>
Date: Wed, 07 Jan 2015 20:39:44 +0200
In-Reply-To: <CACna6rzWaHg=M15q=swf+yqMEB3smRRANuLHkSK1dU1MtG8jgg@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Wed, 7 Jan 2015
 19:12:30 +0100")
Message-ID: <87y4peo2of.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki <zajec5@gmail.com> writes:

> On 7 January 2015 at 18:55, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:
>>
>>> Two lines with more than 80 characters per line have been split in several lines.
>>>
>>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>>
>> Thanks, applied to wireless-drivers-next.git.
>
> Could you still replace it (V4) with an older version (V3)? Before I
> explained V3 was OK Oscar already sent this (worse) V4.

No. I'm not going to rebase a public git tree unless there's a huge
disaster.

But if I see V4 I'm going to assume that's the one I need to apply, not
some older version. If V4 is not good for some reason, make it
ABSOLUTELY clear that I should not apply it. I do not want to start
guessing what patch I should apply.

> This is not critical though, we can always send separated patch for
> one more line > 80 chars.

Please send a followup patch if you want to fix something.

-- 
Kalle Valo
