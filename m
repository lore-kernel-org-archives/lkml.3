Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaDOVCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:02:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38578 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDOVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:02:05 -0400
Message-ID: <534D9E47.30708@wwwdotorg.org>
Date: Tue, 15 Apr 2014 15:01:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/7] net: rfkill: gpio: add device tree support
References: <1397544101-18135-1-git-send-email-wens@csie.org> <1397544101-18135-6-git-send-email-wens@csie.org>
In-Reply-To: <1397544101-18135-6-git-send-email-wens@csie.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:41 AM, Chen-Yu Tsai wrote:

> diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt

> +Optional properties:
> +- clocks		: phandle to clock to enable/disable

Oh, and can't we use clock-names here too, with wording like:

- clocks: Must contain an entry for each entry in clock-names.
  See ../clocks/clock-bindings.txt for details.
- clock-names: May contain any of the following entries:
  - module

