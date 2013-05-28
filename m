Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab3E1ORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:17:00 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44272 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259Ab3E1OQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369738481.3148.9.camel@hornet>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	<201305262323.29519.arnd@arndb.de>
	<30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
	<201305271232.03644.arnd@arndb.de>
	<1369738481.3148.9.camel@hornet>
Date: Tue, 28 May 2013 16:16:57 +0200
Message-ID: <CACRpkdaQfaPQdJ1SDN--JDqcrXs8p6=FaDN+4KtKZF6nLtOvvw@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Linus Walleij <linus.walleij@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:54 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2013-05-27 at 11:32 +0100, Arnd Bergmann wrote:
>> b) add a new KMS driver for this hardware that can be used as an
>> alternative to the existing one and that works with DT.
>
> There are people working on this, just trying to jump through some legal
> hoops to post a RFC. Once this is done we'll be in an interesting
> position of two amba_bus drivers "competing" for the same amba_bus
> device, which I'm not sure how to deal with right now...

Make them mutually exclusive in Kconfig?

Yours,
Linus Walleij
