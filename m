Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3K2HsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:48:00 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34834 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3K2Hr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Fri, 29 Nov 2013 08:47:55 +0100
Message-ID: <CACRpkdYvNwF+dxfiLCHpCL+Ze17PMAMkJo4s-4T4ku1KxDPXxw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 7:15 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch series does the following
> 1> Ports the driver to use irqdomain.
> 2> Adds dt binding support for gpio-davinci.
> 3> Adds DA850 dt support goio.
>
> Changes for v6:
> 1: GPIO driver now migrated to irq domain legacy.
> 2: Fixed review comments pointed by Grygorii.
> 3: Included Ack's.

This series is looking nice, I assume that Sekhar will take this through
the DaVinci tree once he's happy with it. I think I've ACKed all relevant
patches, else tell me.

Yours,
Linus Walleij
