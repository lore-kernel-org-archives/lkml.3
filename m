Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaLDIpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:45:33 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:55066 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaLDIpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:45:32 -0500
MIME-Version: 1.0
In-Reply-To: <1416977280-27319-3-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1416977280-27319-3-git-send-email-rebecca.swee.fun.chang@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 4 Dec 2014 17:45:11 +0900
Message-ID: <CAAVeFuKf4d7i6sNhbAVdN4ZiZKYXrkW5nzftEdE+3PGVO6=oxw@mail.gmail.com>
Subject: Re: [PATCHv4 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 1:47 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Intel Quark X1000 provides a total of 16 GPIOs. The GPIOs are split between
> the legacy I/O bridge and the GPIO controller.
>
> GPIO-SCH is the GPIO pins on legacy bridge for Intel Quark SoC.
> Intel Quark X1000 has 2 GPIOs powered by the core power well and 6 from
> the suspend power well.
>
> This piece of work is derived from Dan O'Donovan's initial work for Quark
> X1000 enabling.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
