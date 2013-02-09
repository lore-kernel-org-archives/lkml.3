Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab3BIOwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:52:09 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:62746 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab3BIOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:52:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
To: Andreas Larsson <andreas@gaisler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
In-Reply-To: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
Date: Sat, 09 Feb 2013 14:52:01 +0000
Message-Id: <20130209145201.B06703E328E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 13:28:41 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP core
> library.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Have you looked at drivers/gpio/gpio-generic.c? This looks to me like
yet another memory mapped gpio controller than could be handled with the
generic driver.

g.

