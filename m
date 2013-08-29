Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3H2SBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:01:24 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39320 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3H2SBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:01:20 -0400
Date: Thu, 29 Aug 2013 11:00:40 -0700
From: Olof Johansson <olof@lixom.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: arm@kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-gpio@vger.kernel.org, kernel@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
Message-ID: <20130829180040.GI18542@quad.lixom.net>
References: <ADE657CA350FB648AAC2C43247A983F0021DAC7DA184@AUSP01VMBX24.collaborationhost.net>
 <1859873512.636800.1377798778897.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1859873512.636800.1377798778897.JavaMail.root@mail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:52:58PM -0400, Vivien Didelot wrote:
> As this patch mainly touches arch/arm/*, Olof/Kevin, would you mind
> applying it?
> 
> The first message in thread is here: https://lkml.org/lkml/2013/7/31/552
> Here are the previous ACKs:
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Looks like i2c or gpio maintainers should be taking it, but since Linus acked
it instead of applied it, I guess we can take it. :)

I'll apply it to next/cleanup for 3.12 if you resend me the patch with the
acks. Thanks!


-Olof
