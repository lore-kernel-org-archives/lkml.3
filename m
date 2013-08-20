Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3HTH2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:28:50 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50301 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HTH2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:28:49 -0400
Date: Tue, 20 Aug 2013 08:28:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/3] mfd: pm8921: include missing linux/module.h
Message-ID: <20130820072844.GF23699@lee--X1>
References: <005201ce9d73$1696e230$43c4a690$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <005201ce9d73$1696e230$43c4a690$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Jingoo Han wrote:

> Include <linux/module.h> in order to fix the following errors.
> 
> drivers/mfd/pm8921-core.c:209:16: error: expected declaration specifiers or '...' before string constant
> drivers/mfd/pm8921-core.c:210:20: error: expected declaration specifiers or '...' before string constant
> drivers/mfd/pm8921-core.c:211:16: error: expected declaration specifiers or '...' before string constant
> drivers/mfd/pm8921-core.c:212:14: error: expected declaration specifiers or '...' before string constant
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patches look good to me 1-3 applied.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
