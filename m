Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbbAGSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:12:33 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40962 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbbAGSMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <87bnmaqxvs.fsf@kamboji.qca.qualcomm.com>
References: <1419766622-10911-1-git-send-email-oscar.forner.martinez@gmail.com>
	<87bnmaqxvs.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 7 Jan 2015 19:12:30 +0100
Message-ID: <CACna6rzWaHg=M15q=swf+yqMEB3smRRANuLHkSK1dU1MtG8jgg@mail.gmail.com>
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

On 7 January 2015 at 18:55, Kalle Valo <kvalo@codeaurora.org> wrote:
> Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:
>
>> Two lines with more than 80 characters per line have been split in several lines.
>>
>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>
> Thanks, applied to wireless-drivers-next.git.

Could you still replace it (V4) with an older version (V3)? Before I
explained V3 was OK Oscar already sent this (worse) V4.

This is not critical though, we can always send separated patch for
one more line > 80 chars.

-- 
Rafał
