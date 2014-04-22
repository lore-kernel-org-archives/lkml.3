Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaDVIcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:32:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35257 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaDVIcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:32:05 -0400
Date: Tue, 22 Apr 2014 09:31:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <cphealy@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_ich: Enable GPIO for Panther Point
Message-ID: <20140422083158.GG17657@lee--X1>
References: <1396712974-13853-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396712974-13853-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Panther Point PCH GPIO configuration is similar to V5 PCHs.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/lpc_ich.c |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
