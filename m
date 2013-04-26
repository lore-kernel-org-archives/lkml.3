Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3DZGxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:53:21 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51147 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab3DZGxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <1366202211-6743-3-git-send-email-andreas@gaisler.com>
References: <1366202211-6743-1-git-send-email-andreas@gaisler.com>
	<1366202211-6743-3-git-send-email-andreas@gaisler.com>
Date: Fri, 26 Apr 2013 08:53:18 +0200
Message-ID: <CACRpkdY2hXEhWFAqFVUKCFtF0aJA3U4V1NOZhgMykyF1K0_yPg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] gpio: grgpio: Add irq support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 2:36 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> The drivers sets up an irq domain and hands out unique irqs to irq
> capable gpio lines regardless of how underlying irq maps to gpio
> lines. Any gpio line can map to any one or none of the irqs of the
> core, independently of each other.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Patch applied, looking good, thanks!

Yours,
Linus Walleij
