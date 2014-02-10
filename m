Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaBJJDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:03:11 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45558 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaBJJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
Date: Mon, 10 Feb 2014 10:02:56 +0100
Message-ID: <CACRpkdb1LFP45Oy0YJ6DSHriSorvHacH=RRWb4LmZ286LJJX0g@mail.gmail.com>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 2:34 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> This adds a driver for the Atmel Microcontroller found on the
> iPAQ h3xxx series. This device handles some keys, the
> touchscreen, and the battery monitoring.

Any opinions on this driver or should we queue it in MFD as-is?

Yours,
Linus Walleij
