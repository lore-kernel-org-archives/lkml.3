Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3CMPOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:14:31 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:39068 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <096801ce1fbc$979d1550$c6d73ff0$%kim@samsung.com>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
	<1360957573-864-1-git-send-email-dianders@chromium.org>
	<1360957573-864-2-git-send-email-dianders@chromium.org>
	<CAHfPSqAtxjYV79VvQZDLtzfyRxkYoMEc4=S2fN=KRNtYOEQ7ig@mail.gmail.com>
	<096801ce1fbc$979d1550$c6d73ff0$%kim@samsung.com>
Date: Wed, 13 Mar 2013 08:14:24 -0700
X-Google-Sender-Auth: YPvrA1weFiJFHt6gUOqOPDzgqw0
Message-ID: <CAD=FV=Wx0HTMUt8ZPiK3HQQDQkN=sNd=-XUZFJaDvcE2bVBTxw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Wed, Mar 13, 2013 at 12:30 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> BTW, Doug, I think, this should be re-worked to use pinctrl. Can you?

Yes, I've already got this locally.  I hadn't sent it up yet since I
wasn't sure whether pinctrl would land before or after this.  I'll
send it up today against my local cherry-pick of Thomas's pinctrl
stuff (since it doesn't seem to be in linux-next nor in
arm-soc/for-next).

Naveen: I'm going to keep your Tested-by on all 3 patches if that's
OK.  The only difference will be the gpio specifier in the device tree
and the change is trivial.

-Doug
