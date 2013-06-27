Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3F0OUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:20:40 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49489 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3F0OUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <201306261602.26800.arnd@arndb.de>
References: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
	<201306261602.26800.arnd@arndb.de>
Date: Thu, 27 Jun 2013 19:50:37 +0530
Message-ID: <CAK9yfHx2sQ38xHDM0CyS_+0HP_gLq+XnaJf5PNyLbOFM_LbR+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: EXYNOS: Remove combiner_init declaration
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        tglx@linutronix.de, t.figa@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 19:32, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 26 June 2013, Sachin Kamat wrote:
>> Commit d243997f ("ARM: EXYNOS: Remove legacy interrupt initialization
>> code") removed the call to combiner_init(). Since there are no more
>> users in the machine code, remove the declaration as well.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Hi,
>
> Your two patches look good to me, but I think there is more that
> can be cleaned up now. See below for my experimental patch.
> I have not gotten around to test or submit that, but feel
> free to take any contents for your own patches.

Thanks Arnd. Let me look into it.

-- 
With warm regards,
Sachin
