Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3ARTgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:36:36 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54531 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ARTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <00df01cdeed1$f08d73b0$d1a85b10$@samsung.com>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
	<1355399644-29417-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdaQ10CgoFXtk4EyqL4LWVpsdEAdrmy5R-_Rqm5fJdqS4A@mail.gmail.com>
	<CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
	<017801cde453$77b03eb0$6710bc10$@samsung.com>
	<CACRpkdZKB1_1U1VZfYADwWfFpBum0Qc88kWtW37h7Z05RtSJfA@mail.gmail.com>
	<00df01cdeed1$f08d73b0$d1a85b10$@samsung.com>
Date: Fri, 18 Jan 2013 20:36:34 +0100
Message-ID: <CACRpkdYGWOqgN2=PQF7GZUuKKiQreXqaHEBmuGy4wteUzmyAqw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: exynos: add exynos5250 SoC specific data
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 2:29 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Linus Walleij wrote:
>> On Thu, Dec 27, 2012 at 5:58 PM, Kukjin Kim <kgene.kim@samsung.com>
>> wrote:
>>
>> > And I think, would be clear if the config could be changed like
> following.
>> >
>> > 8<----------------------------------------------------------------------
>> > From: Kukjin Kim <kgene.kim@samsung.com>
>> > Subject: [PATCH] pinctrl: exynos: change PINCTRL_EXYNOS option
>> >
>> > Since pinctrl-exynos can support exynos4 and exynos5 so changed
>> > the option name to PINCTRL_EXYNOS for more clarity.
>> >
>> > Cc: Thomas Abraham <Thomas.abraham@linaro.org>
>> > Cc: Linus Walleij <linus.walleij@linaro.org>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>> > Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Shall I take this into the pinctrl tree?
>>
> Yes, please :-)

OK I did.

> Just note, regarding Samsung pinctrl changes in the following:
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> next/pinctrl-exynos

Hm. I had to use patch -p1 < ... to apply the patch, which indicates
there may be merge clashes.

Anyway, it's merged now.

Yours,
Linus Walleij
