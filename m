Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3A3KPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:15:49 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49452 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3A3KPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:15:47 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZp8wM+ho9gg51YRx4ScJVw9RnPCpVJXKJgZ=xngi6=Jg@mail.gmail.com>
References: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
	<CACRpkdYj_e6+iT7iAVtA8_t=4e_2Lxo9duozXccfcbKY8fGk7A@mail.gmail.com>
	<CAK9yfHwav_u3mjVqNdX4kY=LyUW30vr6AMGUExfGKuJn2KH8qQ@mail.gmail.com>
	<076401cdfe9f$6a0f5fa0$3e2e1ee0$@samsung.com>
	<CACRpkdZp8wM+ho9gg51YRx4ScJVw9RnPCpVJXKJgZ=xngi6=Jg@mail.gmail.com>
Date: Wed, 30 Jan 2013 15:45:46 +0530
Message-ID: <CAK9yfHxhwRXCeqb0YbkP74MXgnOOqTNVvtv0ykHnVBB+aiCbKg@mail.gmail.com>
Subject: Re: Failure due to missing (Exynos related) pinctrl patch
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 30 January 2013 15:18, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jan 30, 2013 at 5:08 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Sachin Kamat wrote:
>>>
>>> >> This patch is required along with the
>>> >> patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
>>> >> (mainline commit Id: e4a5da51) which has already made it into
>>> >> mainline. Without the missing patch we get the following boot up
>>> >> warnings and subsequent failures with dt boot on 4412 based board:
>>> >
>>> > Hm I didn't realize there was a dependency between these
>>> > patches, oh well, better get the pull for the pinctrl tree finished
>>> > off then...

>
> Torvalds has already pulled it in -> problem solved. :-)
>

I tested this on Linus T.'s latest tip (2e51b231) and the problem
still persists :(

You sent the following patch in your pull request to Linus T.:
Kukjin Kim (1):
      pinctrl: samsung: removing duplicated condition for PINCTRL_SAMSUNG

However, the missing dependent patch is:

"pinctrl: exynos: change PINCTRL_EXYNOS option"

-- 
With warm regards,
Sachin
