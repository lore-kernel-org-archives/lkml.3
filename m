Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbaFLHZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:25:14 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40493 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaFLHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZhJONmqV8SNLxxo1srcRbdmrDwH4x1UiwE=fp1MY370Q@mail.gmail.com>
References: <1401355531-632-1-git-send-email-linus.walleij@linaro.org>
	<CAOh2x=njLfu5D0=oH6kmdm9hnk3e1RXEsFtwsXJcOJ-JFcm1XQ@mail.gmail.com>
	<CACRpkdZhJONmqV8SNLxxo1srcRbdmrDwH4x1UiwE=fp1MY370Q@mail.gmail.com>
Date: Thu, 12 Jun 2014 12:55:11 +0530
Message-ID: <CAKohpo=ckbyetHBOTuB=OuHvbhsaf7UAHEqC_JuXXh+Ny3CTmw@mail.gmail.com>
Subject: Re: [PATCH] RFT: pinctrl: spear: switch plgpio to irqchip helpers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "pratyush.anand" <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2014 12:53, Linus Walleij <linus.walleij@linaro.org> wrote:
> Hum? If the maintainers can't maintain the thing, then maybe the
> machine should just be deleted?

It still has some users :)

> I will just apply this patch then.

Sure.
