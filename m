Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaBJKmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:42:20 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:46982 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaBJKmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140204191947.GV22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-10-git-send-email-ulf.hansson@linaro.org>
	<20140204191947.GV22609@sirena.org.uk>
Date: Mon, 10 Feb 2014 11:42:15 +0100
Message-ID: <CAPDyKFqV+5T5jFgjWZ9zkbC3Oijq=7fVBhM9BDLQtDa_c8Yftg@mail.gmail.com>
Subject: Re: [PATCH 09/17] spi: pl022: Simplify clock handling
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

On 4 February 2014 20:19, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 04:58:50PM +0100, Ulf Hansson wrote:
>> Make use of clk_prepare_enable and clk_disable_unprepare to simplify
>> code. No functional change.
>
> I went ahead and applied this since it looks good and seems like an
> unrelated cleanup to the runtime PM stuff which seems to be where the
> interdependencies are - thanks!  It's on a separate branch with the
> already applied change so if it does need to be cross merged we can do
> that easily or even drop the branch.

Thanks Mark, it seems like a good approach.

Kind regards
Ulf Hansson
