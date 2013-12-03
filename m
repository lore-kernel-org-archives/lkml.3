Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3LCJbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:31:16 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34939 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3LCJbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <2715269.S45Tc0DQGQ@flatron>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
	<CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
	<5293ACA6.7060403@bracey.fi>
	<2715269.S45Tc0DQGQ@flatron>
Date: Tue, 3 Dec 2013 10:31:12 +0100
Message-ID: <CACRpkdYDONQ-7U3hGYnx7jb0_Y=rcOcvy-2F1dO058FfOO4stg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using pinfunc.
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Bracey <kevin@bracey.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kmpark@infradead.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 1:30 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> IMHO a way to specify a default safe state of all pins (with lowest power
> consumption, without possibility of glitching external devices, etc.)
> would be really useful for Samsung platforms (and probably Renesas ones
> as Kevin wrote).

I'm following :-)

Now if we could see some more details and a patch, that would
be great ...

Yours,
Linus Walleij
