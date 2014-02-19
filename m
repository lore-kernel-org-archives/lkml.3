Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaBSSIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:08:09 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51850 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBSSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140219151040.GH2669@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-7-git-send-email-ulf.hansson@linaro.org>
	<CAPDyKFombL2-Rt46QpXPNWe5PeGQnOGmQQNfYd5MdYdEePn-4w@mail.gmail.com>
	<20140219151040.GH2669@sirena.org.uk>
Date: Wed, 19 Feb 2014 19:02:54 +0100
Message-ID: <CAPDyKFqvdm73s9wDPA=z7LkiMmtLhGkcpwEdbS13zGHE5spQNw@mail.gmail.com>
Subject: Re: [PATCH 06/17] spi: pl022: Let runtime PM callbacks be available
 for CONFIG_PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 16:10, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Feb 19, 2014 at 03:20:07PM +0100, Ulf Hansson wrote:
>
>> Also note that, Russell has already applied the corresponding part in
>> the amba bus (patch 1)
>
> Why would this depend on an AMBA patch and if it does surely the two
> need to be merged together somehow?

There are no immediate dependency, sorry for confusion.

I just wanted to highlight that the amba has converted to the new
SET_PM_RUNTIME_PM_OPS. It means the amba bus' runtime PM callbacks are
available for CONFIG_PM.

Kind regards
Uffe
