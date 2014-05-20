Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaETMOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:14:45 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54362 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaETMOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:14:44 -0400
Date: Tue, 20 May 2014 13:14:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/2] regulator: tps6586x: Add support for the TPS658640
Message-ID: <20140520121439.GK24991@lee--X1>
References: <1400580843-29484-1-git-send-email-alban.bedel@avionic-design.de>
 <1400580843-29484-2-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400580843-29484-2-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The TPS658640 has a different set of output voltage for most LDO and
> the RTC LDO isn't settable. This chip also report 2 different version
> ID, as the datasheet doesn't list the possible values the second ID
> has simply been named TPS658640v2.
> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
> v2: Fixed the number of bits for the voltage selection of LDO_RTC
>     Removed superflous whitspace after the tps658640_regulator array
> ---
>  drivers/mfd/tps6586x.c                 |  4 ++++
>  drivers/regulator/tps6586x-regulator.c | 36 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps6586x.h           |  2 ++
>  3 files changed, 42 insertions(+)

MFD parts look okay to me.

Mark can you tag the branch and ping it over to me please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
