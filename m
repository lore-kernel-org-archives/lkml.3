Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307Ab3E1OV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:21:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33563 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab3E1OVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:21:07 -0400
Message-ID: <1369750864.2939.1.camel@hornet>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Pawel Moll <pawel.moll@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 May 2013 15:21:04 +0100
In-Reply-To: <CACRpkdaQfaPQdJ1SDN--JDqcrXs8p6=FaDN+4KtKZF6nLtOvvw@mail.gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	 <201305262323.29519.arnd@arndb.de>
	 <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
	 <201305271232.03644.arnd@arndb.de>	<1369738481.3148.9.camel@hornet>
	 <CACRpkdaQfaPQdJ1SDN--JDqcrXs8p6=FaDN+4KtKZF6nLtOvvw@mail.gmail.com>
X-Mailer: Evolution 3.6.4-0ubuntu1
Mime-Version: 1.0
X-OriginalArrivalTime: 28 May 2013 14:21:05.0122 (UTC) FILETIME=[96B53C20:01CE5BAE]
X-MC-Unique: 113052815210503901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 15:16 +0100, Linus Walleij wrote:
> On Tue, May 28, 2013 at 12:54 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> > On Mon, 2013-05-27 at 11:32 +0100, Arnd Bergmann wrote:
> >> b) add a new KMS driver for this hardware that can be used as an
> >> alternative to the existing one and that works with DT.
> >
> > There are people working on this, just trying to jump through some legal
> > hoops to post a RFC. Once this is done we'll be in an interesting
> > position of two amba_bus drivers "competing" for the same amba_bus
> > device, which I'm not sure how to deal with right now...
> 
> Make them mutually exclusive in Kconfig?

Certainly an option.

I wouldn't mind having both compiled as modules and loading one or the
other, but it wouldn't fly with "=y"...

Paweł


