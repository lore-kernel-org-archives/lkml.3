Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3ENIRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:17:04 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57747 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3ENIRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-2-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:17:00 +0200
Message-ID: <CACRpkdZSGiYDY=PbtLyVKZCFLTbhSq7crCDATwpeFkU9UOe3Fg@mail.gmail.com>
Subject: Re: [PATCH 1/9] ARM: ux500: Remove duplicated assignment of ab8500_platdata
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

> Since: "05ec260 mfd: db8500-prcmu: update resource passing", the AB8500's
> platform data 'ab8500_platdata' is passed directly as an attribute to
> 'db8500_prcmu_pdata', so there's no requirement to assign it a second
> time. In fact, it's only due to an ordering issue that the entire
> 'db8500_prcmu_pdata' data structure isn't completely over-written by the
> assignment in u8500_init_devices().
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Good catch! Patch applied.

Yours,
Linus Walleij
