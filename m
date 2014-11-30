Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaK3QXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:23:09 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaK3QXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:23:07 -0500
Message-ID: <547B4464.9090300@nod.at>
Date: Sun, 30 Nov 2014 17:23:00 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linus.walleij@linaro.org, harald@ccbib.org
CC: javier.martinez@collabora.co.uk, acourbot@nvidia.com, swarren@nvidia.com,
        jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: iio: dht11 broken
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Staring with 3.12 gpiolib refuses to set an GPIO used as IRQ into output mode.
see commit d468bf9e (gpio: add API to be strict about GPIO IRQ usage)
The dht driver does this and is therefore not functional.
As the dht11 driver got merged in 3.13 there is a high chance that it never worked.

Harald, are you aware of this issue?

Thanks,
//richard
