Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLHTjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:39:09 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:50061 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaLHTjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:39:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Date: Mon, 08 Dec 2014 20:38:15 +0100
Message-ID: <2129851.JzMQjVqeL2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418064468-8512-3-git-send-email-rjui@broadcom.com>
References: <1418064468-8512-3-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:R3SxUhg+HQbkDUZwycXWYWXJoz5ZXAi4ao7jMmpk/lCoXNOE9Cu
 U67O14jcVkmLJLbkg6xV5KKXrEPeWfcu9xdr01JQwk8UWE4XUwuTE9diSPsaexBmwsfXBD/
 SnIxeNumIIVCnXLaRfBJB8Ia0ITZ+Wtw1jrQtJdLazMjgJeRvL6emuQxPVPNyF+FYMwcC1U
 RlLpJhPsvvZtAzdoakhDA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 10:47:44 Ray Jui wrote:
> +
> +- no-drv-stregnth:
> +    Specifies the GPIO controller does not support drive strength configuration
> +
> 

Typo:

	strength, not stregnth

Otherwise looks good.

	Arnd
