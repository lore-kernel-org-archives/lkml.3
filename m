Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3K2Psu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:48:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48170 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3K2Pst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:48:49 -0500
Message-ID: <5298B75E.3080104@ti.com>
Date: Fri, 29 Nov 2013 10:48:46 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <nsekhar@ti.com>, <prabhakar.csengg@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC v1 2/9] gpio: introduce GPIO_DAVINCI kconfig option
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com> <1385494815-15740-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1385494815-15740-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 02:40 PM, Grygorii Strashko wrote:
> The compatible to Davinci GPIO HW block is used by other TI SoCs, like
> Keystone, where GPIO support is declared as optional.
> 
> Hence, introduce GPIO_DAVINCI Kconfig option which will allow to enable
> Davinci GPIO driver for Keystone SoCs when needed. At same time, kept
> Davinci GPIO driver enabled for Davinci SoCs by default.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
Already acked

