Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbbACJbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 04:31:15 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:43234 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbACJbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 04:31:10 -0500
MIME-Version: 1.0
In-Reply-To: <20150102171123.GC3298@atomide.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
	<CAPDyKFpxvE4x_-PV=KN0HKY5cNug-ss9m5KCjNdebR1LDOJi5w@mail.gmail.com>
	<CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
	<CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
	<CAD=FV=UzJo=KE7Snb2v=dNodmf_ky97o3xyUHUAZqb1Kq10d1A@mail.gmail.com>
	<20150102171123.GC3298@atomide.com>
Date: Sat, 3 Jan 2015 10:31:09 +0100
Message-ID: <CAPDyKFo6eQ7P5XjSWDKGPMz0NAwwENPK=YAbnY5WY8HFbDK5mA@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Doug Anderson <dianders@chromium.org>
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

On 2 January 2015 at 18:11, Tony Lindgren <tony@atomide.com> wrote:
> * Doug Anderson <dianders@chromium.org> [150102 09:09]:
>> Ulf,
>>
>> On Tue, Dec 30, 2014 at 2:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> >>> In v5, I don't find a patch 1/4. Anyway, I have taken patch 2->4.
>> >>
>> >> Ah, maybe because it wasn't sent to linux-mmc?  I messed that up and
>> >> will try to do better in the future.  Sorry.  :(  You were in the To
>> >> line, though.  You can see at
>> >> <https://patchwork.kernel.org/patch/5425241/>.
>> >>
>> >> Do you want me to repost it and CC linux-mmc with Tony's Ack?
>> >
>> > I suggest you have a look at my next branch and to verify that I
>> > haven't screwed things up. If so, either I should drop the patches and
>> > you make a resend or if it's possible to just send an incremental path
>> > on top?
>>
>> The patches that landed look good to me, but I think you might break
>> omap3pandora's WiFi until you land patch #1 in the series.  It has
>> Tony's Ack so I think he intends for you to land it in your tree.
>>
>> [v5,1/4] ARM: OMAP2+: Make sure pandora_wl1251_init_card() applies to SDIO only
>
> Yes please pick that one up too to avoid breakage. The changes to the
> mach-omap2/board-*.c files are only minimal fixes, so it should not
> conflict with anything I'll be applying.

Tony, Doug,

I have picked it up from the arm patch tracker and applied it for my
next branch. I have put it prior the following patch:
"mmc: core: Support the optional init_card() callback for MMC and SD".

Kind regards
Uffe

>
> Regards,
>
> Tony
