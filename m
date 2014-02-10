Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBJKZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:25:47 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44887 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaBJKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:25:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140204184909.GT22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<20140204184909.GT22609@sirena.org.uk>
Date: Mon, 10 Feb 2014 11:25:41 +0100
Message-ID: <CAPDyKFq+p5x+XFSRNJN6qVOCNhACU=JSs3rtH+0peVmpdYkZ3g@mail.gmail.com>
Subject: Re: [PATCH 00/17] amba: PM fixups for amba bus and some amba drivers
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 19:49, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 04:58:41PM +0100, Ulf Hansson wrote:
>
>> The fixes for the amba bus needs to be merged prior to the other, thus I think
>> it could make sense to merge this complete patchset through Russell's tree,
>> if he and the other maintainers think this is okay.
>
> What are the actual dependencies for the SPI bit?  AFAICT it's probably
> the first patch needs the bus updating?

Correct!

At this point I thought it made sense to collect all this patches,
since it adopts to use the new SET_PM_RUNTIME_PM_OPS macro from the PM
core.

In principle I wanted to visualize in one go how driver's system
suspend|resume callbacks could be implemented for three similar
scenarios.

Kind regards
Ulf Hansson
