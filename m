Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3ENIfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:35:48 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:51021 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3ENIfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-8-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-8-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:35:45 +0200
Message-ID: <CACRpkdYTBdtRkY1e-Qnzdk27wpKFkNKTtmXazjTDxTh1hmXmgw@mail.gmail.com>
Subject: Re: [PATCH 7/9] pinctrl: abx500: Specify failed sub-driver by ID
 instead of driver_data
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If a sub-driver has not been specified correctly, there is a good chance
> that plat_id is NULL, hence using an attribute of plat_id in the error
> message is likely to not only fail the driver but Oops the kernel. Use
> the failed ID instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Good patch! Applied to the pinctrl fixes.

Yours,
Linus Walleij
