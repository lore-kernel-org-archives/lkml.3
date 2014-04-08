Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaDHNLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:11:42 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55101 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaDHNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396961147-2754-1-git-send-email-maxime.coquelin@st.com>
References: <1396961147-2754-1-git-send-email-maxime.coquelin@st.com>
Date: Tue, 8 Apr 2014 15:11:36 +0200
Message-ID: <CACRpkdbMFaqtPh43sss-eZbY7gFVQHg_+WH7TsJ04KkZvNJg5g@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: st: use gpiolib irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 2:45 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> The v1 was sent by Linus (https://lkml.org/lkml/2014/4/4/287).
> Two changes were necessary to make it to work properly on STiH416:
>   1 - dev reference was not passed to the gpio_chip struct, causing a panic
>   2 - gpiochip_irqchip_add passed IRQ_TYPE_NONE as default type, which caused
> lot of warnings at init time. I choose IRQ_TYPE_LEVEL_LOW as default.

Thanks a lot for fixing this Maxime, this version of the patch
applied!

Yours,
Linus Walleij
