Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbbABRGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:06:55 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58925 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbABRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
	<CAPDyKFpxvE4x_-PV=KN0HKY5cNug-ss9m5KCjNdebR1LDOJi5w@mail.gmail.com>
	<CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
	<CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
Date: Fri, 2 Jan 2015 09:06:51 -0800
X-Google-Sender-Auth: OqQ0v5e87aztV_bdSW9meZjDTVA
Message-ID: <CAD=FV=UzJo=KE7Snb2v=dNodmf_ky97o3xyUHUAZqb1Kq10d1A@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Tony Lindgren <tony@atomide.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>,
        Joe Perches <joe@perches.com>, Axel Lin <axel.lin@ingics.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf,

On Tue, Dec 30, 2014 at 2:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>> In v5, I don't find a patch 1/4. Anyway, I have taken patch 2->4.
>>
>> Ah, maybe because it wasn't sent to linux-mmc?  I messed that up and
>> will try to do better in the future.  Sorry.  :(  You were in the To
>> line, though.  You can see at
>> <https://patchwork.kernel.org/patch/5425241/>.
>>
>> Do you want me to repost it and CC linux-mmc with Tony's Ack?
>
> I suggest you have a look at my next branch and to verify that I
> haven't screwed things up. If so, either I should drop the patches and
> you make a resend or if it's possible to just send an incremental path
> on top?

The patches that landed look good to me, but I think you might break
omap3pandora's WiFi until you land patch #1 in the series.  It has
Tony's Ack so I think he intends for you to land it in your tree.

[v5,1/4] ARM: OMAP2+: Make sure pandora_wl1251_init_card() applies to SDIO only

-Doug
