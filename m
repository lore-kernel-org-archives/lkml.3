Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3BXBBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 20:01:48 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:41476 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373Ab3BXBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 20:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <31669750.ZZOiY1AEPv@flatron>
References: <201302231855.47560.heiko@sntech.de>
	<5027662.bpQdq7jhyn@flatron>
	<CACRpkdaFv=V8M_Ztb5-hrYm6YnXiG6fg6Z13y3NVFdszBk=7ZQ@mail.gmail.com>
	<31669750.ZZOiY1AEPv@flatron>
Date: Sun, 24 Feb 2013 02:01:45 +0100
Message-ID: <CACRpkdYBjZgEo6qEyBOcYuPzpQUAZ9x-kvFabz0y0pEQs35sKw@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 1:58 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> [Me]
>> Surely you know this when setting up the pdata from your machine?
>
> Cases 2) and 3) are both DT-enabled cases, where there is no pdata coming
> from board-specific code.
(...)
> Note that we are talking here about a temporary solution. The legacy DT-
> based pin configuration will go away after all the DT-enabled platforms
> using this driver get migrated to pin control and so will the need to
> check if pin control is available.

So use AUXDATA, and you get a pdata for that driver?

Yours,
Linus Walleij
