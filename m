Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaLQIHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:07:19 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43735 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaLQIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:07:16 -0500
MIME-Version: 1.0
In-Reply-To: <1418696307-19392-1-git-send-email-rjui@broadcom.com>
References: <rjui@broadcom.com> <1418696307-19392-1-git-send-email-rjui@broadcom.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 17:06:54 +0900
Message-ID: <CAAVeFuKYDVdMYqHRij2U3fDQUOhwa8-OYDb4ZNkXevX+qWy04Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] Add gpio support to Broadcom Cygnus SoC
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:18 AM, Ray Jui <rjui@broadcom.com> wrote:
> This patchset contains the initial GPIO support for the Broadcom Cygnus SoC.
> Cygnus has 3 GPIO controllers: 1) the ASIU GPIO; 2) the chipCommonG GPIO;
> and 3) the ALWAYS-ON GPIO. All 3 types of GPIO controllers are supported by
> the same Cygnus GPIO driver

No objections for this v6. The series,

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
