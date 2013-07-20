Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3GTRGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:06:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:51149 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3GTRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <1372170465-28450-3-git-send-email-james.hogan@imgtec.com>
References: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
	<1372170465-28450-3-git-send-email-james.hogan@imgtec.com>
Date: Sat, 20 Jul 2013 19:06:05 +0200
Message-ID: <CACRpkdbQa8OMjbG3ZdtFrmj2bk4j9JDbXXCSQXnyekNr9iz8gQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] gpio-tz1090-pdc: add TZ1090 PDC gpio driver
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

> Add a GPIO driver for the low-power Powerdown Controller GPIOs in the
> TZ1090 SoC.
>
> The driver is instantiated by device tree and supports interrupts for
> the SysWake GPIOs only.
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

Patch applied.

Yours,
Linus Walleij
