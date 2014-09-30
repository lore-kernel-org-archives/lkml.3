Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaI3MNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:13:37 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52444 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaI3MNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <3256402.M8e92DFkbg@wuerfel>
References: <3256402.M8e92DFkbg@wuerfel>
Date: Tue, 30 Sep 2014 14:13:35 +0200
Message-ID: <CACna6ryoq0A_6745aemJPQTEZxncmDRkCOPB3ZUHtNhXqXf2Fw@mail.gmail.com>
Subject: Re: [PATCH] spi: bcm53xx: add BCMA dependency
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2014 14:09, Arnd Bergmann <arnd@arndb.de> wrote:
> The BCMA bus framework can be disabled on bcm53xx, which leads to a link
> error when building the SPI driver:

You missed this one:
https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/?h=for-next&id=933fc7b06ca62741fd5067edab13068d13b3cb35
