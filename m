Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967497AbaLLMJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:09:01 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:60893 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967013AbaLLMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:08:59 -0500
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
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Date: Fri, 12 Dec 2014 13:08:05 +0100
Message-ID: <1918116.UxUgDPTmcq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:qxBHolvI/oAurUGNr3KHzWtiUcWqDYSzkJFbOyrE27Vo2Y2yWrm
 JH6Sajyi0YwlbBsFfSxLFB7xwP2C9yJ74yiNOuracKpIX+dQeiQ0HbdsT0Zk9b09jGsoV8t
 nHGJIfW5GeEcUZJzwqEMi20WVlw4PUCrIa25CFUFwD+hDU9NtH4IJV7LEe1wowlJD/ZPdhZ
 nfDN4M9/ONB9diwaOyYbw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 16:05:04 Ray Jui wrote:
> +
> +- linux,gpio-base:
> +    Base GPIO number of this controller
> +
> 

We've NAK'ed properties like this multiple times before, and it
doesn't get any better this time. What are you trying to achieve
here?

	Arnd
