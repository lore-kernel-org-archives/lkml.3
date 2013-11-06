Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3KFLzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:55:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46517 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3KFLzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:55:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131106104658.GE11602@sirena.org.uk>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
	<1383732985-18928-7-git-send-email-lee.jones@linaro.org>
	<20131106104658.GE11602@sirena.org.uk>
Date: Wed, 6 Nov 2013 12:55:51 +0100
Message-ID: <CACRpkdZgi9Egvm585Y9tJpmj0YX-oJBDg-C7pCu91Pf5ALMGLg@mail.gmail.com>
Subject: Re: [PATCH 06/13] ASoC: ux500_pcm: Extend ux500 MSP binding for enumeration
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:46 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Nov 06, 2013 at 10:16:18AM +0000, Lee Jones wrote:

>> + - id               : MSP ID - used during component registration
>
> I have no idea what this means or how one would pick the number?  It
> looks like something purely internal to the driver...

Actually it's quite common when we have several HW blocks of the
same thing to add something like an id. For example for different
GPIO banks.

But in this case I guess it may make more sense to flag one MSP
for RX and one for TX or something?

There are also two more such MSPs for streaming audio to the
Bluetooth audio portions.

Yours,
Linus Walleij
