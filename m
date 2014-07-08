Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaGHHwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:52:07 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:33354 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaGHHwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:52:04 -0400
MIME-Version: 1.0
In-Reply-To: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
Date: Tue, 8 Jul 2014 09:52:03 +0200
Message-ID: <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
From: Linus Walleij <linus.walleij@linaro.org>
To: Houcheng Lin <houcheng@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 3:37 PM, Houcheng Lin <houcheng@gmail.com> wrote:

> The Problem
> -----------
> The reset signal on a hardware board is send either:
>     - during machine initialization
>     - during bus master's initialization

I just thought about this a bit, since there isn't already a generic GPIO
reset driver, just call this drivers/reset/reset-gpio.c and make the
ability to deferral just a configuration detail of the GPIO reset driver.

Yours,
Linus Walleij
