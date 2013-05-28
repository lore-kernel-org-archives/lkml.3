Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487Ab3E1PKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:10:30 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41667 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934368Ab3E1PK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <3950519.8yj1SQodNQ@wuerfel>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	<CACRpkdaQfaPQdJ1SDN--JDqcrXs8p6=FaDN+4KtKZF6nLtOvvw@mail.gmail.com>
	<1369750864.2939.1.camel@hornet>
	<3950519.8yj1SQodNQ@wuerfel>
Date: Tue, 28 May 2013 18:10:26 +0300
Message-ID: <CAHp75Vern=-6KjfjsC+Y6N9H+yhb7eGC_Ui1Uf+8Y3069fqNow@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Daniel Tang <dt.tangr@gmail.com>,
        Lionel Debroux <lionel_debroux@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 5:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>         depends on KMS_ARMCLCD != 'y'
>         depends on 'm' if KMS_ARMCLCD

Those two above could be one actually.

Just my 2 cents.

--
With Best Regards,
Andy Shevchenko
