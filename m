Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbaLBXnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:43:23 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:39031 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319AbaLBXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:43:17 -0500
MIME-Version: 1.0
In-Reply-To: <547E4815.7010100@samsung.com>
References: <1417553397-460-1-git-send-email-dianders@chromium.org>
	<1417553397-460-2-git-send-email-dianders@chromium.org>
	<547E4815.7010100@samsung.com>
Date: Tue, 2 Dec 2014 15:43:16 -0800
X-Google-Sender-Auth: 161E42z0RlWZtM_YCesBRVmGN38
Message-ID: <CAD=FV=VqirunbqKtC7hXTKNXfnDjj2fBMa7sRuJLvdnGeqxUUw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mmc: core: Support the optional init_card()
 callback for MMC and SD
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        gsoutade@neotion.com, Axel Lin <axel.lin@ingics.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>, Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Tue, Dec 2, 2014 at 3:15 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Doug.
>
> I think good that this patch is separated to two patches.
> (board file and codes relevant to mmc.)

Yes, good idea.  I've spun v5 with this.

-Doug
