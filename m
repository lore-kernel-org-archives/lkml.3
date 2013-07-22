Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3GVJLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:11:55 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50053 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3GVJLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:11:54 -0400
Date: Mon, 22 Jul 2013 10:11:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mfd: ucb1x00: explicitely include linux/device.h
Message-ID: <20130722091148.GH4681@laptop>
References: <1374361659-3064-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374361659-3064-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Andrea Adami wrote:

> Fix
> linux/include/linux/mfd/ucb1x00.h:137:17: error: field 'dev' has incomplete type
> 
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
> ---
>  include/linux/mfd/ucb1x00.h | 1 +
>  1 file changed, 1 insertion(+)

I'm going to fix the commit message a little, but patch applied.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
