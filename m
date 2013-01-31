Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3AaU4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:56:24 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:56611 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3AaU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:56:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAOY=C6GReEpO7ukOS8WiQgdFFAreaYK1YrZ8HQrQ9dGMFObAdQ@mail.gmail.com>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-2-git-send-email-stigge@antcom.de>
	<CAOY=C6ERX=2HdvmtAW-__947_-P8r=Lvp88KzZDQdf4kAuRB5Q@mail.gmail.com>
	<51053268.2000002@antcom.de>
	<CAOY=C6GReEpO7ukOS8WiQgdFFAreaYK1YrZ8HQrQ9dGMFObAdQ@mail.gmail.com>
Date: Thu, 31 Jan 2013 21:56:20 +0100
Message-ID: <CACRpkdaEG3UNntPGy1wnXyKahtDOWXUnqSvr-RG4ak-Ho3+AMw@mail.gmail.com>
Subject: Re: [PATCH 1/6 v14] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:30 PM, Stijn Devriendt <highguy@gmail.com> wrote:

> This is one of the warts of the GPIO API, if you ask me (and probably
> others too).
> Using a resource without allocating it first is just asking for
> trouble. It's one of those
> things pinctl was designed to solve... I've been thinking about
> spending spare time
> sending out patches converting all implicit requests and then removing
> the implicit
> request, but spare time is limited...

It would be much appreciated. We can make good use of all
help we can get in this area...

Yours,
Linus Walleij
