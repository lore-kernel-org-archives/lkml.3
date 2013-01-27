Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3A0Dea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 22:34:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49849 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3A0De3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 22:34:29 -0500
Date: Sun, 27 Jan 2013 03:33:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
Message-ID: <20130127033358.GA20672@sirena.org.uk>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357752671-30222-1-git-send-email-lars@metafoo.de>
X-Cookie: Noone ever built a statue to a critic.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 06:31:09PM +0100, Lars-Peter Clausen wrote:

> The second function spi_sync_transfer() takes a SPI device and an array of
> spi_transfers. It will allocate a new spi_message (on the stack) and add all
> transfers in the array to the message. Finally it will call spi_sync() on the
> message.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

for the helpers, we should try to get them merged separately to the
coccinelle rules if there's issue with those.
