Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaLQKot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:44:49 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35683 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751206AbaLQKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:44:47 -0500
Date: Wed, 17 Dec 2014 10:44:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ray Jui <rjui@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Message-ID: <20141217104428.GV11285@n2100.arm.linux.org.uk>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
 <1918116.UxUgDPTmcq@wuerfel>
 <CAAVeFuL2MKRA7YLm_wsyftNy-sxgEYPrmqBm8XTRZQb66YF-qw@mail.gmail.com>
 <1628217.66frkAqHMc@wuerfel>
 <CAAVeFuJhiten-eVLCa2sMG-nsRwjPMiZap8UJM1kNCuRyK-b1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJhiten-eVLCa2sMG-nsRwjPMiZap8UJM1kNCuRyK-b1w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:45:01AM +0900, Alexandre Courbot wrote:
> Actually we are not that far from being able to do completely without
> any GPIO number, and maybe that's what we should aim for. I think the
> only remaining offender is the sysfs interface.

And that is a user API, and there's lots of users of it (eg, on Raspberry
Pi platforms.)  So changing it isn't going to be easy - I'd say that it's
impractical.

What you're suggesting would be like re-numbering Linux syscalls.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
