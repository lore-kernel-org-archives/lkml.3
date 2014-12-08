Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaLHLWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:22:44 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:58312 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaLHLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:22:42 -0500
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
Subject: Re: [PATCH v2 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Date: Mon, 08 Dec 2014 12:22:20 +0100
Message-ID: <2594176.SCRFa6Sb3O@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418006316-324-2-git-send-email-rjui@broadcom.com>
References: <1418006316-324-2-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:xoB7Q7vwSq4kkj6lSC9z5zih/e5ZDpg24oZaU2riqWn+z8ZR34P
 tr+zG4iWIVQ94SNdF1fy/RG8P4w9+J3Pt+TQ5UX/iqOH5LdU+R2NWRwwU0bqoCWa0Suj70W
 5KeEte5nzYhI8njAiX/Msf95Oc4lYn8n+HaDb/ellLiIPQWDcwq3O8jUAz9D0Qcwh8lCFOj
 9KTdQ0y/duvfhEnWWlW+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2014 18:38:32 Ray Jui wrote:
> +Required properties:
> +
> +- compatible:
> +    Currently supported Cygnus GPIO controllers include:
> +    "brcm,cygnus-ccm-gpio": ChipcommonG GPIO controller
> +    "brcm,cygnus-asiu-gpio": ASIU GPIO controller
> +    "brcm,cygnus-crmu-gpio": CRMU GPIO controller

How different are these? If they are almost the same, would it
be better to use the same compatible string for all of them and
describe the differences in extra properties?

If they are rather different, maybe you should have a separate
binding and driver for each?

	Arnd
