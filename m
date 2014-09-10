Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaIJRGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:06:15 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62681 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaIJRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <54108939.5050208@gmx.net>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
	<1410089869-6611-3-git-send-email-info@lategoodbye.de>
	<20140909182211.GG3896@leverpostej>
	<540F523D.4010904@lategoodbye.de>
	<20140910141853.GA4994@leverpostej>
	<54108939.5050208@gmx.net>
Date: Wed, 10 Sep 2014 14:06:11 -0300
Message-ID: <CAOMZO5CK=c+=y2BgsYRKVujgn3yRWYjOXkz0EwzBEVXDVpq0Gg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator driver
From: Fabio Estevam <festevam@gmail.com>
To: Stefan Wahren <wahrenst@gmx.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 2:24 PM, Stefan Wahren <wahrenst@gmx.net> wrote:

> sorry i don't have a clue. In the original code there isn't a comment about
> the reason. Currently there is no init of the vddio regulator by the kernel
> and everything works fine.
>
> @Fabio: Do you have any doubts?

I would say, just use and report whatever value comes from the
bootloader. No need to force a particular regulator  output.
