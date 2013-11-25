Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3KYRSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:18:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34414 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3KYRSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:18:01 -0500
Message-ID: <52938646.6030306@wwwdotorg.org>
Date: Mon, 25 Nov 2013 10:17:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] pinctrl: provide documentation pointer
References: <1385390706-28722-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1385390706-28722-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 07:45 AM, Linus Walleij wrote:
> The PIN_CONFIG_OUTPUT parameter is really tricky to understand
> and needs an explicit pointer to the documentation.

> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h

>   * @PIN_CONFIG_OUTPUT: this will configure the pin in output, use argument

Well, while you're touching that...
s/in/as an/   s/, use/. Use/

> - *	1 to indicate high level, argument 0 to indicate low level.
> + *	1 to indicate high level, argument 0 to indicate low level. (Please
> + *	Documentation/pinctrl.txt, section "GPIO mode pitfalls" for a

Add "see" to the start of that line.

> + *	discussion around this parameter.)

(no need to resend to fix that, from my side at least)
