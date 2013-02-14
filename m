Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3BNIci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:32:38 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60862 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3BNIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:32:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130213200226.GA14465@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
	<20130213061853.GA4043@brouette>
	<CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
	<20130213092154.GA4481@brouette>
	<CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
	<20130213140843.GA21308@brouette>
	<CAKfTPtCuj4xZi2mBZP_Vz-zzySwBLKPn2aNkdqf6g8sVJoyS+A@mail.gmail.com>
	<CAKfTPtDrTyof40Lk7MzdqEon2dkN=RZNEvP5BQSJVKP-EYsCXw@mail.gmail.com>
	<20130213184706.GA23803@brouette>
	<20130213200226.GA14465@brouette>
Date: Thu, 14 Feb 2013 09:32:35 +0100
Message-ID: <CAKfTPtAA_k6C_1YMjm2ZxU_Y4VgEk6QOwee9ShbD3Jw8GwY1eg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Damien Wyart <damien.wyart@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 February 2013 21:02, Damien Wyart <damien.wyart@gmail.com> wrote:
>> Bingo, that was the problem in my setup: as the patch was applied
>> through a script with others, I had missed the error message about the
>> conflict (I have also another conflict which can be safely ignored so
>> the new one did not catch my eye)... So the patch was only
>> half-applied, and the final code is broken.
>
>> How did you solve the conflict (I am not a scheduler expert)? I can
>> retry running the patched kernel with your resolution, to check if
>> everything is ok.
>
> After looking a bit more, the conflict resolution seemed straighforward,

Yes the resolution is straightforward and your patch is ok.

> so I gave it a go. The attached version booted fine, so the initial
> problem was purely PEBCAK... Sorry for the noise!

Now, i know that my patch on frederic's branch, boots on a x86_64,
Core i7 920 :-)

Vincent

>
> --
> Damien
