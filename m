Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3GUObh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:31:37 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62386 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3GUObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <1372046406-3127-4-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	<1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
	<1372046406-3127-4-git-send-email-kevin.strasser@linux.intel.com>
Date: Sun, 21 Jul 2013 16:31:35 +0200
Message-ID: <CACRpkdYs-qaLU7jVrC2cuhcnc8FTv69bQNz5vEMOFsUxyaHkyw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] gpio: Kontron PLD gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
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

On Mon, Jun 24, 2013 at 6:00 AM, Kevin Strasser
<kevin.strasser@linux.intel.com> wrote:

> From: Guenter Roeck <linux@roeck-us.net>
>
> Add gpio support for the on-board PLD found on some Kontron embedded modules.
>
> Originally-From: Michael Brunner <michael.brunner@kontron.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> Acked-by: Darren Hart <dvhart@linux.intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Applied this to the GPIO tree now that the deps are upstream.

I did actually think that Sam would take this through MFD but
maybe I was not clear enough :-(

Yours,
Linus Walleij
