Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaB0Nh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:37:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaB0Nhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:37:52 -0500
Message-ID: <530F3F8B.4090509@ti.com>
Date: Thu, 27 Feb 2014 19:07:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Cyril Chemparathy <cyril.chemparathy@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 0/5] ARM: davinci: tnetv107x removal
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fixed Cyril's e-mail address)

On Wednesday 26 February 2014 06:13 PM, Arnd Bergmann wrote:
> This series removes the TI davinci/tnetv107x platform that
> has evidently bitrotted to the point where it's completely
> useless. While we could probably fix it and add a defconfig,
> it appears that there are actually no users of this platform,
> and it complicates the davinci code base because it's
> incompatible with all the other SoCs in there that are
> based on ARM926T.
> 
> The five patches are completely independent of one another,
> and applying them out of order is fine since we just want
> to remove the code. However, I'm looking for an Ack from
> Cyril Chemparathy and Sekhar Nori first, to be sure we
> won't need this code in the future. Kevin Hilman has
> already mentioned that he sees no reason to keep this
> code.

Acked-by: Sekhar Nori <nsekhar@ti.com>

Regards,
Sekhar
