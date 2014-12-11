Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbaLKQJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:09:15 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57716 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaLKQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141211123106.GU11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
	<20141210235347.GT11764@sirena.org.uk>
	<CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
	<20141211123106.GU11764@sirena.org.uk>
Date: Thu, 11 Dec 2014 08:09:13 -0800
X-Google-Sender-Auth: hcXxZf4E4efGkbKCYLNeFgRDVeI
Message-ID: <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alexandru Stan <amstan@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thu, Dec 11, 2014 at 4:31 AM, Mark Brown <broonie@kernel.org> wrote:
> This is just an implementation detail, everything you're saying here
> applies equally to any user specifying by tolerance rather than range.
> If the reason for doing this is to fix that problem then a new API isn't
> the way to go about it.

OK, I'll give a shot at taking my code and using it as a new
implementation for regulator_set_voltage_tol().  In the SD card code
I'll pick some reasonable tolerances--they won't be exactly what the
spec says, but they ought to be good enough.  If Ulf comes back and
yells at me then we can revisit adding a new API.

Thanks!

-Doug
