Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaBNQn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:43:28 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41579 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:43:26 -0500
Date: Fri, 14 Feb 2014 16:43:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC V2] mfd: da9063: Add support for production silicon variant
 code
Message-ID: <20140214164319.GB30687@lee--X1>
References: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add the correct silicon variant code ID (0x5) to the driver. This
> new code is the 'production' variant code ID for DA9063.
> 
> This patch will remove the older variant code ID which matches the
> pre-production silicon ID (0x3) for the DA9063 chip.
> 
> There is also some small amount of correction done in this patch:
> it splits the revision code and correctly names it according to
> the hardware specification and moves the dev_info() call before
> the variant ID test.
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
