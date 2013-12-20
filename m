Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3LTTu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:50:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3LTTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:50:56 -0500
Date: Fri, 20 Dec 2013 11:51:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH] MAINTAINERS: take maintainership for Energy Micro efm32
 SoCs
Message-ID: <20131220195106.GA21124@kroah.com>
References: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 08:39:03PM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I think this can best go in via armsoc, but needs acks for clk, clocksource,
> spi and tty/serial.

For the serial driver:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
