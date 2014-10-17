Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaJQIsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:48:10 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61204 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaJQIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141016100648.GB2255@lahna.fi.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-3-git-send-email-rebecca.swee.fun.chang@intel.com> <20141016100648.GB2255@lahna.fi.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 17 Oct 2014 17:47:47 +0900
Message-ID: <CAAVeFuL=axwtLGF5Vvmgq1aZ9yaZXOhPvv7f_HWmsJkhVMYwEg@mail.gmail.com>
Subject: Re: [PATCHv3 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
To: Mika Westerberg <mika.westerberg@intel.com>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 7:06 PM, Mika Westerberg
<mika.westerberg@intel.com> wrote:
> On Thu, Oct 16, 2014 at 11:51:14AM +0800, Chang Rebecca Swee Fun wrote:
>> Intel Quark X1000 provides a total of 16 GPIOs. The GPIOs are split between
>> the legacy I/O bridge and the GPIO controller.
>>
>> GPIO-SCH is the GPIO pins on legacy bridge for Intel Quark SoC.
>> Intel Quark X1000 has 2 GPIOs powered by the core power well and 6 from
>> the suspend power well.
>>
>> This piece of work is derived from Dan O'Donovan's initial work for Quark
>> X1000 enabling.
>>
>> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
