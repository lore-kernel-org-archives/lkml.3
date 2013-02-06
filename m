Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3BFPIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:08:12 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41911 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3BFPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:08:09 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
References: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com>
	<CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
Date: Thu, 7 Feb 2013 00:08:08 +0900
Message-ID: <CAAmzW4NKuWUJtO_K0GMxBMDo4Y4JNpMBp=fLsJfBNhTzUuHZPg@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: sched: correct update_sched_clock()
From: JoonSoo Kim <js1304@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

2013/2/6 Linus Walleij <linus.walleij@linaro.org>:
> On Wed, Feb 6, 2013 at 6:21 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>
>> If we want load epoch_cyc and epoch_ns atomically,
>> we should update epoch_cyc_copy first of all.
>> This notify reader that updating is in progress.
>
> If you think the patch is finished, put it into Russell's patch tracker:
> http://www.arm.linux.org.uk/developer/patches/

Ah... Okay.
Thanks for notifying me.
