Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaCRJLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:11:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45178 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaCRJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:11:09 -0400
Date: Tue, 18 Mar 2014 09:11:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: Add support for S2MPA01 device
Message-ID: <20140318091103.GH25478@lee--X1>
References: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the necessary entries required for S2MPA01 multi-function
> device. While at it also convert whitespaces to tabs in core.h.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> No change since v3
> ---
>  drivers/mfd/sec-core.c              |   49 ++++++++-
>  include/linux/mfd/samsung/core.h    |   16 ++-
>  include/linux/mfd/samsung/irq.h     |   50 +++++++++
>  include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
>  4 files changed, 297 insertions(+), 10 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
