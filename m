Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab3FSIgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:36:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43641 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <1371589469-32700-4-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	<1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
	<1371589469-32700-4-git-send-email-kevin.strasser@linux.intel.com>
Date: Wed, 19 Jun 2013 10:36:34 +0200
Message-ID: <CACRpkdYEuC_czRHZycgN81u8QEU-n5XjV5-DJgpF4AJMKJpxQA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gpio: Kontron PLD gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:04 PM, Kevin Strasser
<kevin.strasser@linux.intel.com> wrote:

> Add gpio support for the on-board PLD found on some Kontron embedded modules.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

This is looking good.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
