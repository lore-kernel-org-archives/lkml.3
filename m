Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJPDon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:44:43 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60285 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJPDol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <1413406066-16257-1-git-send-email-zyw@rock-chips.com>
References: <1413405987-16196-1-git-send-email-zyw@rock-chips.com>
	<1413406066-16257-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 15 Oct 2014 20:44:40 -0700
X-Google-Sender-Auth: pICiBNmIOBf9Ul6uG3_N_Lc10Ow
Message-ID: <CAD=FV=Ve4=BuqqrboJ5uyz6+RAxAEvAe+G2myf+BCk8q2+3LGA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: add suspend and resume for RK3288
From: Doug Anderson <dianders@chromium.org>
To: Chris <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Oct 15, 2014 at 1:47 PM,  <zyw@rock-chips.com> wrote:
> +static const struct platform_suspend_ops rk3288_suspend_ops = {
> +       .enter = rk3288_suspend_enter,
> +       .valid = suspend_valid_only_mem,
> +};

As per offline discussion, let's add the regulator calls in prepare / finish.
