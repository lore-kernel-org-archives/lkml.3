Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3AaN7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:59:11 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:51634 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3AaN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:59:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxhwRXCeqb0YbkP74MXgnOOqTNVvtv0ykHnVBB+aiCbKg@mail.gmail.com>
References: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
	<CACRpkdYj_e6+iT7iAVtA8_t=4e_2Lxo9duozXccfcbKY8fGk7A@mail.gmail.com>
	<CAK9yfHwav_u3mjVqNdX4kY=LyUW30vr6AMGUExfGKuJn2KH8qQ@mail.gmail.com>
	<076401cdfe9f$6a0f5fa0$3e2e1ee0$@samsung.com>
	<CACRpkdZp8wM+ho9gg51YRx4ScJVw9RnPCpVJXKJgZ=xngi6=Jg@mail.gmail.com>
	<CAK9yfHxhwRXCeqb0YbkP74MXgnOOqTNVvtv0ykHnVBB+aiCbKg@mail.gmail.com>
Date: Thu, 31 Jan 2013 14:59:08 +0100
Message-ID: <CACRpkdb5at3vtguNn3NRRzL9sPB2DPU5Z2bfm53VhBzsMFOWpw@mail.gmail.com>
Subject: Re: Failure due to missing (Exynos related) pinctrl patch
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 11:15 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 30 January 2013 15:18, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Wed, Jan 30, 2013 at 5:08 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>> Sachin Kamat wrote:
>>>>
>>>> >> This patch is required along with the
>>>> >> patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
>>>> >> (mainline commit Id: e4a5da51) which has already made it into
>>>> >> mainline. Without the missing patch we get the following boot up
>>>> >> warnings and subsequent failures with dt boot on 4412 based board:
>>>> >
>>>> > Hm I didn't realize there was a dependency between these
>>>> > patches, oh well, better get the pull for the pinctrl tree finished
>>>> > off then...
>
>>
>> Torvalds has already pulled it in -> problem solved. :-)
>>
>
> I tested this on Linus T.'s latest tip (2e51b231) and the problem
> still persists :(
>
> You sent the following patch in your pull request to Linus T.:
> Kukjin Kim (1):
>       pinctrl: samsung: removing duplicated condition for PINCTRL_SAMSUNG
>
> However, the missing dependent patch is:
>
> "pinctrl: exynos: change PINCTRL_EXYNOS option"

Aha how typically chaotical.

And that is in the middle of the devel branch that people are
basing their development on.

Not much to do, I cherry-picked that patch to the fixes branch
and hope that git will cope. (It usually does.)

Yours,
Linus Walleij
