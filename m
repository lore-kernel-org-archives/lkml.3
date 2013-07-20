Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3GTRCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:02:39 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43832 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3GTRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <1372170465-28450-2-git-send-email-james.hogan@imgtec.com>
References: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
	<1372170465-28450-2-git-send-email-james.hogan@imgtec.com>
Date: Sat, 20 Jul 2013 19:02:36 +0200
Message-ID: <CACRpkdbZLzZa9Ri7tYuk7d_QKNa+XyAjgZ6MEzTer7c81fke8A@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] gpio-tz1090: add TZ1090 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 4:27 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
> This doesn't include low-power GPIOs as they're controlled separately
> via the Powerdown Controller (PDC) registers.
>
> The driver is instantiated by device tree and supports interrupts for
> all GPIOs.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-doc@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
> Changes in v4:

Patch applied now. It is better to not stress things and queue this for v3.12
now that the pinctrl portions are in for v3.11.

Yours,
Linus Walleij
