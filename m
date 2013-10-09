Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3JIIza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:55:30 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46992 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JIIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <1380846199-12829-2-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-2-git-send-email-syin@broadcom.com>
Date: Wed, 9 Oct 2013 10:55:27 +0200
Message-ID: <CACRpkdaMODd9=fZPC+-FMJ1tWw95DBGjsu4DEzKqrNhGpYSARA@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: Add void * to pinctrl_pin_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 2:23 AM, Sherman Yin <syin@broadcom.com> wrote:

> drv_data is added to the pinctrl_pin_desc for drivers to define additional
> driver-specific per-pin data.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
> Change-Id: I78b2c44b93d88b04897fd0af80ffce213e338d6b

Why are you giving me this funky Gerrit stuff along with the patch?
It's not like I have any use for it, and anything below the three
dashes will be deleted when applying.

The patch is OK but won't be applied until some driver is
using it (i.e. this BRCM one...)

Yours,
Linus Walleij
