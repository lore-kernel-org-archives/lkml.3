Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaFCE3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:29:43 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:54917 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaFCE3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <1401355531-632-1-git-send-email-linus.walleij@linaro.org>
References: <1401355531-632-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 3 Jun 2014 09:59:41 +0530
X-Google-Sender-Auth: cE8wdOPKGewlww01TBam8D4g-6Y
Message-ID: <CAOh2x=njLfu5D0=oH6kmdm9hnk3e1RXEsFtwsXJcOJ-JFcm1XQ@mail.gmail.com>
Subject: Re: [PATCH] RFT: pinctrl: spear: switch plgpio to irqchip helpers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        "pratyush.anand" <pratyush.anand@st.com>,
        Mohit Kumar <mohit.kumar@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        linux-gpio@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This switches the SPEAr PLGPIO driver over to using the irqchip
> helpers.
>
> As part of this effort, also get rid of the strange irq_base
> calculation and failure to use d->hwirq for obtaining a local
> irqchip offset.
>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
> Cc: spear-devel@list.st.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> SPEAr folks: please make sure to test this, it is part of an
> important GPIO refactoring round. If it doesn't work: please do
> an honest attempt at troubleshooting.

Both me and shiraz can't test it anymore, we switched our jobs :)
And not sure who else can do it..

@Pratyush/Mohit ?
