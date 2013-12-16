Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3LPMEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:04:06 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:63837 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3LPMEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:04:02 -0500
Message-ID: <1387195436.13062.139.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Daniel Mack <zonque@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>, linux-mmc@vger.kernel.org
Date: Mon, 16 Dec 2013 16:03:56 +0400
In-Reply-To: <52AEEAF4.3010703@metafoo.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 	 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 	 <1386901645-28895-4-git-send-email-ynvich@gmail.com>
	 	 <201312142006.26979.arnd@arndb.de>
	  <1387049660.7152.317.camel@host5.omatika.ru> <52AECEB2.4070807@gmail.com>
	 <1387194450.13062.134.camel@host5.omatika.ru> <52AEEAF4.3010703@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 12:58 +0100, Lars-Peter Clausen wrote:
> Btw. any driver that parses the dmas property manually should be considered
> broken. This is a classical layering violation. The layout of the dma
> specifier is DMA controller specific and should be completely transparent to
> the device driver.

PXA as a whole is broken in this respect at the moment. The problem is
how to move to a "fixed" state without breaking things which work now.

