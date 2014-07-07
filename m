Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaGGOxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:53:21 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61383 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaGGOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <1403091577-10232-2-git-send-email-harinik@xilinx.com>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
	<1403091577-10232-2-git-send-email-harinik@xilinx.com>
Date: Mon, 7 Jul 2014 16:53:19 +0200
Message-ID: <CACRpkdYZ8gQ_-z3Ue3WZZ4FiV8dhw_BZez2-PLpeiBTs-UnNFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add Zynq GPIO devicetree bindings documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harini.katakam@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 1:39 PM, Harini Katakam <harinik@xilinx.com> wrote:

> From: Harini Katakam <harini.katakam@xilinx.com>
>
> Add gpio-zynq bindings documentation.
>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>
> v2 changes:
> Improve description.
(...)
> +- #gpio-cells          : Should be two. First cell is used to mention
> +                         pin number.

Don't call this "pin number", call it "GPIO line number".

Yours,
Linus Walleij
