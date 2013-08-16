Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3HPP6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:58:06 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48067 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3HPP6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130816155156.GA6953@roeck-us.net>
References: <20130809173326.75aed3b6@mail.gmx.de>
	<CACRpkdYe9+Fb-YO4Mn885YtY_YiRWsG1U+sFXo-poThpDOL1dw@mail.gmail.com>
	<20130816155156.GA6953@roeck-us.net>
Date: Fri, 16 Aug 2013 17:58:02 +0200
Message-ID: <CACRpkdaxdkriaO-ufq6JSFONecBRHYstfnUBojGOwQfBaXb8ZA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Fix bit masking in Kontron PLD GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Michael Brunner <mibru@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 5:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> I think Michael just went on vacation.
>
> Clean version is below. He must have sent it to me separately
> because it worked for me.

Yeah this worked fine ... strange.

Patch applied.

Yours,
Linus Walleij
