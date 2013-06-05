Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3FEFY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:24:59 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41638 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3FEFY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <1369145282-14419-3-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
	<1369145282-14419-3-git-send-email-prakash.pm@ti.com>
Date: Wed, 5 Jun 2013 13:24:57 +0800
Message-ID: <CAN1soZw9F-LeUVcYmJ7wKOnacKsBgkGookMrDM11KNsQ0sxw9w@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-single: enhance to configure
 multiple pins of different modules
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: Walleij Linus <linus.walleij@linaro.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux Russell <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, peter.ujfalusi@ti.com,
        grant.likely@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:08 PM, Manjunathappa, Prakash
<prakash.pm@ti.com> wrote:
> Add support to configure multiple pins in each register, existing
> implementation added by [1] does not support full fledge multiple pin
> configuration in single register, reports a pin clash when different
> modules configure different bits of same register. The issue reported
> and discussed here
> http://www.spinics.net/lists/arm-kernel/msg235213.html
>
> With pinctrl-single,bits-per-mux property specified, use function-mask
> property to find out number pins to configure. Allocate and register
> pin control functions based sub mask.
>
> Tested on da850/omap-l138 EVM.
> does not support variable submask for pins.
> does not support pinconf.
>
> [1] "pinctrl: pinctrl-single: Add pinctrl-single,bits type of mux"
> (9e605cb68a21d5704839a192a46ebcf387773704),
>
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Excuse me for response late.

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
