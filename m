Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3LFI0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:26:47 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49461 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LFI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:26:45 -0500
Date: Fri, 6 Dec 2013 08:26:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
Subject: Re: [PATCH 1/6] regulator: ab8500: use devm_regulator_register()
Message-ID: <20131206082640.GA13093@lee--X1>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Dec 2013, Jingoo Han wrote:

> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/ab8500.c |   24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
