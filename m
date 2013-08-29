Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3H2RxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:53:06 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59800 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3H2RxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:53:04 -0400
Date: Thu, 29 Aug 2013 13:52:58 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: arm@kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-gpio@vger.kernel.org, kernel@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Message-ID: <1859873512.636800.1377798778897.JavaMail.root@mail>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DAC7DA184@AUSP01VMBX24.collaborationhost.net>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to
 linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC29 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this patch mainly touches arch/arm/*, Olof/Kevin, would you mind
applying it?

The first message in thread is here: https://lkml.org/lkml/2013/7/31/552
Here are the previous ACKs:

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Regards,
Vivien
