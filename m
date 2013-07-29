Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3G2Qjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:39:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64749 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3G2Qj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <1374602524-3398-7-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	<1374602524-3398-7-git-send-email-wsa@the-dreams.de>
Date: Mon, 29 Jul 2013 18:39:29 +0200
Message-ID: <CACRpkdba0FHnWsCkNOEevmqvD9hZ_mroJ+mqbpjecG7sTAfBFw@mail.gmail.com>
Subject: Re: [PATCH 06/27] drivers/i2c/busses: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 8:01 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Please apply via the subsystem-tree.

Are you talking to yourself ;-)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
