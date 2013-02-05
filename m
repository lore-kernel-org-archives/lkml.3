Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3BEOIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:08:04 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:53163 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3BEOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:08:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
In-Reply-To: <20130127033358.GA20672@sirena.org.uk>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de> <20130127033358.GA20672@sirena.org.uk>
Date: Tue, 05 Feb 2013 14:07:55 +0000
Message-Id: <20130205140755.33FCD3E1265@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013 03:33:59 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jan 09, 2013 at 06:31:09PM +0100, Lars-Peter Clausen wrote:
> 
> > The second function spi_sync_transfer() takes a SPI device and an array of
> > spi_transfers. It will allocate a new spi_message (on the stack) and add all
> > transfers in the array to the message. Finally it will call spi_sync() on the
> > message.
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good to me also. Go ahead and merge this series through the iio
tree since it is the first user.

g.

