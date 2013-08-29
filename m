Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3H2TgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:36:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60287 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3H2TgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:36:01 -0400
Date: Thu, 29 Aug 2013 12:35:21 -0700
From: Olof Johansson <olof@lixom.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: arm@kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-gpio@vger.kernel.org, kernel@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH RESEND] gpio: (gpio-pca953x) move header to
 linux/platform_data/
Message-ID: <20130829193521.GJ18542@quad.lixom.net>
References: <1377804254-15955-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377804254-15955-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 03:24:14PM -0400, Vivien Didelot wrote:
> This patch moves the pca953x.h header from include/linux/i2c to
> include/linux/platform_data and updates existing support accordingly.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Thanks, applied.


-Olof
