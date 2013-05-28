Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab3E1Kyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:54:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34521 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3E1Kyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:54:45 -0400
Message-ID: <1369738481.3148.9.camel@hornet>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 May 2013 11:54:41 +0100
In-Reply-To: <201305271232.03644.arnd@arndb.de>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	 <201305262323.29519.arnd@arndb.de>
	 <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
	 <201305271232.03644.arnd@arndb.de>
X-Mailer: Evolution 3.6.4-0ubuntu1
Mime-Version: 1.0
X-OriginalArrivalTime: 28 May 2013 10:54:42.0295 (UTC) FILETIME=[C1F7C870:01CE5B91]
X-MC-Unique: 113052811544310301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 11:32 +0100, Arnd Bergmann wrote:
> b) add a new KMS driver for this hardware that can be used as an
> alternative to the existing one and that works with DT.

There are people working on this, just trying to jump through some legal
hoops to post a RFC. Once this is done we'll be in an interesting
position of two amba_bus drivers "competing" for the same amba_bus
device, which I'm not sure how to deal with right now...

Paweł


