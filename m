Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3JUIfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:35:51 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53341 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3JUIfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130906093800.GF32654@lee--X1>
References: <1378454473-24508-1-git-send-email-sachin.kamat@linaro.org>
	<20130906093800.GF32654@lee--X1>
Date: Mon, 21 Oct 2013 14:05:50 +0530
Message-ID: <CAK9yfHz8S-kM7pS9kakPEbqCyX006Jx-BUg9992z6gzBJbyRwA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ab8500-charger: Check return value of regulator_enable
From: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, anton@enomsg.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 September 2013 15:08, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 06 Sep 2013, Sachin Kamat wrote:
>
>> Check the return value of regulator_enable to silence the following
>> type of warnings:
>> drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
>> of ‘regulator_enable’, declared with attribute warn_unused_result
>> [-Wunused-result]
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>> Compile tested.
>>
>> Changes since v2:
>> * removed redundant assignment to false.
>> Changes since v1:
>> * converted dev_err and return to dev_warn as suggested by Lee Jones.
>> ---
>>
>>  drivers/power/ab8500_charger.c |   16 ++++++++++++----
>>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> Looks good now.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>

Ping on this series, Anton..


-- 
With warm regards,
Sachin
