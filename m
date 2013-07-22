Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3GVJMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:12:36 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:40355 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3GVJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:12:34 -0400
Date: Mon, 22 Jul 2013 10:12:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mfd: mcp: add missing linux/device.h header
Message-ID: <20130722091227.GI4681@laptop>
References: <1374361662-3094-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374361662-3094-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Andrea Adami wrote:

> Fix
> linux/include/linux/mfd/mcp.h:22:16: error: field 'attached_device' has incomplete type
> linux/include/linux/mfd/mcp.h:48:23: error: field 'drv' has incomplete type
> 
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
> ---
>  include/linux/mfd/mcp.h | 2 ++
>  1 file changed, 2 insertions(+)

I'm going to fix the commit message a little, but patch applied.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
