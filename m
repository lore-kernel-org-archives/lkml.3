Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab3DZHe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:34:29 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:36634 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3DZHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <1366216474.8215.1.camel@chaos.site>
References: <1366216474.8215.1.camel@chaos.site>
Date: Fri, 26 Apr 2013 09:34:25 +0200
Message-ID: <CACRpkdYnQZwoejB87OcZTTuvR1049vJaj__8kJZtgFEpPUc7JA@mail.gmail.com>
Subject: Re: [PATCH] gpio: ucb1400: Can be built as a module
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Marek Vasut <marex@denx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 6:34 PM, Jean Delvare <jdelvare@suse.de> wrote:

> With the recent code cleanup from Marek Vasut, driver gpio-ucb1400 can
> be built as a module, so change symbol GPIO_UCB1400 from bool to
> tristate.
>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>

As Sam has merged the depent patch to MFD, applied this with Marek's
ACK.

Yours,
Linus Walleij
