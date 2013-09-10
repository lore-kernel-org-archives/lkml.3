Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3IJBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:48:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57280 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJBsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:48:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522E7A54.6050903@roeck-us.net>
Date: Mon, 09 Sep 2013 18:48:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Build failures in drivers/of/of_reserved_mem.c due to missing asm/dma-contiguous.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/of/of_reserved_mem.c:14:32: fatal error: asm/dma-contiguous.h: No such file or directory
  #include <asm/dma-contiguous.h>

Seen with
	arm64:defconfig
	mips:nlm_xlp_defconfig
	mips:cavium_octeon_defconfig

Guenter
