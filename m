Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaDNK6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:58:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42720 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDNK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:58:48 -0400
Date: Mon, 14 Apr 2014 11:57:58 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Roger Quadros <rogerq@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v4 2/2] reset: Add GPIO support to reset controller
 framework
Message-ID: <20140414115758.2c0c8a9d@alan.etchedpixels.co.uk>
In-Reply-To: <1397463709-19405-2-git-send-email-p.zabel@pengutronix.de>
References: <1397463709-19405-1-git-send-email-p.zabel@pengutronix.de>
	<1397463709-19405-2-git-send-email-p.zabel@pengutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds support for GPIO controlled reset pins on peripheral ICs to the reset
> controller framework. Currently there is no support for specifying a delay
> between assertion and de-assertion of the reset signal, so this has to be
> handled by the drivers.

Lots of GPIO controllers are doing posted writes to the fabric so surely
your delay will be wrong ?


Alan
