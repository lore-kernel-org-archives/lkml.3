Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3BDUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:42:39 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:34258 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3BDUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:42:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1soZxOX24QCYOTXmVOmNGu-+ShUPaBScxh38C=p7-v_2OZnw@mail.gmail.com>
References: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
	<1359816246-3979-2-git-send-email-acourbot@nvidia.com>
	<CAN1soZxOX24QCYOTXmVOmNGu-+ShUPaBScxh38C=p7-v_2OZnw@mail.gmail.com>
Date: Mon, 4 Feb 2013 21:42:37 +0100
Message-ID: <CACRpkdY83TqF5zzKrD1LNQ1reL5Z+HPKHAWwLxLWj4fYr3SSZw@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: pxa: tosa: do not use gpiochip_reserve()
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arch@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 1:29 AM, Haojian Zhuang <haojian.zhuang@gmail.com> wrote:

> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Thanks!

> Linus,
>
> Could you help to merge this patch into your gpio git tree? I think
> that both of them should go through one git tree.

Yep, already merged it.

Yours,
Linus Walleij
