Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3FCHRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:17:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52037 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab3FCHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:17:31 -0400
X-Sasl-enc: PTAyNIAJXuskboQzdiyiTexMx20zvkh0qxuCFBd2gzt+ 1370243849
Message-ID: <51AC4308.2030200@ladisch.de>
Date: Mon, 03 Jun 2013 09:17:28 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: introduce fw_driver.probe and .remove methods
References: <51A20AEE.7060201@sakamocchi.jp> <20130526233513.1a95d0d5@stein> <20130526225757.GA32606@kroah.com> <51A742A1.8010108@sakamocchi.jp> <20130603002749.4fdc36a5@stein>
In-Reply-To: <20130603002749.4fdc36a5@stein>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> FireWire upper layer drivers are converted from generic
>     struct driver.probe() and .remove()
> to bus-specific
>     struct fw_driver.probe() and .remove().

Acked-by: Clemens Ladisch <clemens@ladisch.de>
for these:
>  sound/firewire/isight.c             |   44 ++++++------
>  sound/firewire/scs1x.c              |   39 +++++-----
>  sound/firewire/speakers.c           |  106 +++++++++++-----------------

> Although all in-tree drivers are being converted to the new methods,
> support for the old methods is left in place for the time being, aiming
> to avoid conflicts if/when new drivers are being merged into the
> mainline via other trees.

AFAICS it's unlikely that any of the new sound drivers will be merged soon
enough for this to matter.


Regards,
Clemens
