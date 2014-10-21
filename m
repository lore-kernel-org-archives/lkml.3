Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaJUIcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:32:03 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60991 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaJUIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <1412057357-23375-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412057357-23375-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 21 Oct 2014 10:32:00 +0200
Message-ID: <CACRpkdY-4RbaoP5YTwp4=YbYC8q+sEZ4PtT4K3S4dhcuTbEc+Q@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: st: Fix Sparse error
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 8:09 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This change fixes below sparse error,
> drivers/pinctrl/pinctrl-st.c:1515:31: error: incompatible types for operation (>)
> drivers/pinctrl/pinctrl-st.c:1515:31:    left side has type void [noderef] <asn:2>*irqmux_base
> drivers/pinctrl/pinctrl-st.c:1515:31:    right side has type int
>
> Cc: Maxime Coquelin <maxime.coquelin@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

No comments so patch applied.

Yours,
Linus Walleij
