Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3HPPFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:05:36 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64367 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3HPPFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130809173306.1ba24b59@mail.gmx.de>
References: <20130809173306.1ba24b59@mail.gmx.de>
Date: Fri, 16 Aug 2013 17:05:32 +0200
Message-ID: <CACRpkdb-V9f8eoSKQ8xOtKNh=9RFUDXAcgere-FsBXwk7E5fYQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Fix platform driver name in Kontron PLD GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 5:33 PM, Michael Brunner <mibru@gmx.de> wrote:

> This patch changes the driver name to be consistent with the name that
> is registered as cell name in the MFD driver. Otherwise the driver won't
> load.
>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Patch applied!

Yours,
Linus Walleij
