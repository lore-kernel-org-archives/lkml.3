Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3A3Dyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:54:50 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53170 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3A3Dys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYj_e6+iT7iAVtA8_t=4e_2Lxo9duozXccfcbKY8fGk7A@mail.gmail.com>
References: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
	<CACRpkdYj_e6+iT7iAVtA8_t=4e_2Lxo9duozXccfcbKY8fGk7A@mail.gmail.com>
Date: Wed, 30 Jan 2013 09:24:47 +0530
Message-ID: <CAK9yfHwav_u3mjVqNdX4kY=LyUW30vr6AMGUExfGKuJn2KH8qQ@mail.gmail.com>
Subject: Re: Failure due to missing (Exynos related) pinctrl patch
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch is required along with the
>> patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
>> (mainline commit Id: e4a5da51) which has already made it into
>> mainline. Without the missing patch we get the following boot up
>> warnings and subsequent failures with dt boot on 4412 based board:
>
> Hm I didn't realize there was a dependency between these
> patches, oh well, better get the pull for the pinctrl tree finished
> off then...

Ideally those 2 patches should have been squashed together.

-- 
With warm regards,
Sachin
