Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3DHUrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:47:13 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51308 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab3DHUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:47:12 -0400
Message-ID: <51632CCD.6080900@free-electrons.com>
Date: Mon, 08 Apr 2013 22:47:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: sunxi: Rename wemac functions to emac
References: <1364389953-20688-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364389953-20688-1-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Le 27/03/2013 14:12, Maxime Ripard a écrit :
> The pin functions associated to the ethernet controller were introduced
> with the label "wemac", which was the name of the ethernet driver in the
> allwinner source tree, while the real name of the IP is actually "emac",
> as advertised in several documents including the datasheet.
> 
> Since this is part of the device tree bindings, and that these part of
> the bindings have not yet be released in a kernel version, it seems like
> the good timing to change it and assure consistency.

This patch depends on patches you applied earlier, could you merge it if
you agree with it?

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
