Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaJBQSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:18:30 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51110 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaJBQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
	<1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
Date: Thu, 2 Oct 2014 13:18:26 -0300
Message-ID: <CAOMZO5BzUEsOt_J6YBPOjg2BQdiYW6Y9thys+8Ri5j05znjV8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
From: Fabio Estevam <festevam@gmail.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 9:59 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:

> +config REGULATOR_MXS
> +       tristate "Freescale MXS on-chip regulators"
> +       depends on ARCH_MXS
> +       default y if ARCH_MXS

I would suggest removing this 'default y if ARCH_MXS' line. Thanks
