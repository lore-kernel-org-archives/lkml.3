Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab3AQJ0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:26:15 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38204 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3AQJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:26:13 -0500
MIME-Version: 1.0
In-Reply-To: <1357555480-24022-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
	<1357555480-24022-3-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 17 Jan 2013 10:26:13 +0100
Message-ID: <CACRpkdYBwf+zYKf+e4_sVu7VCVjknmyj64V7BXOJvndt4F5-qA@mail.gmail.com>
Subject: Re: [PATCH 02/11] spi/pxa2xx: convert to the pump message infrastructure
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, broonie@opensource.wolfsonmicro.com,
        chao.bi@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 11:44 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> The SPI core provides infrastructure for standard message queueing so use
> that instead of handling everything in the driver. This simplifies the
> driver.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Wohoo!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
