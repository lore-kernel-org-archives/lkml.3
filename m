Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbbABRPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:15:15 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61749 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbbABRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:15:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX198eC0k2NIGFhXSbp9nJPnZ
Date: Fri, 2 Jan 2015 09:11:23 -0800
From: Tony Lindgren <tony@atomide.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
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
        =?utf-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>,
        Joe Perches <joe@perches.com>, Axel Lin <axel.lin@ingics.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
Message-ID: <20150102171123.GC3298@atomide.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
 <CAPDyKFpxvE4x_-PV=KN0HKY5cNug-ss9m5KCjNdebR1LDOJi5w@mail.gmail.com>
 <CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
 <CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
 <CAD=FV=UzJo=KE7Snb2v=dNodmf_ky97o3xyUHUAZqb1Kq10d1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UzJo=KE7Snb2v=dNodmf_ky97o3xyUHUAZqb1Kq10d1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Doug Anderson <dianders@chromium.org> [150102 09:09]:
> Ulf,
> 
> On Tue, Dec 30, 2014 at 2:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >>> In v5, I don't find a patch 1/4. Anyway, I have taken patch 2->4.
> >>
> >> Ah, maybe because it wasn't sent to linux-mmc?  I messed that up and
> >> will try to do better in the future.  Sorry.  :(  You were in the To
> >> line, though.  You can see at
> >> <https://patchwork.kernel.org/patch/5425241/>.
> >>
> >> Do you want me to repost it and CC linux-mmc with Tony's Ack?
> >
> > I suggest you have a look at my next branch and to verify that I
> > haven't screwed things up. If so, either I should drop the patches and
> > you make a resend or if it's possible to just send an incremental path
> > on top?
> 
> The patches that landed look good to me, but I think you might break
> omap3pandora's WiFi until you land patch #1 in the series.  It has
> Tony's Ack so I think he intends for you to land it in your tree.
> 
> [v5,1/4] ARM: OMAP2+: Make sure pandora_wl1251_init_card() applies to SDIO only

Yes please pick that one up too to avoid breakage. The changes to the
mach-omap2/board-*.c files are only minimal fixes, so it should not
conflict with anything I'll be applying.

Regards,

Tony
