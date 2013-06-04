Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3FDHdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:33:41 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63642 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab3FDHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:33:40 -0400
Date: Tue, 4 Jun 2013 08:33:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] mfd: ssbi: Use devm_* and simplify code
Message-ID: <20130604073335.GK3370@gmail.com>
References: <1370288384-3122-1-git-send-email-sboyd@codeaurora.org>
 <1370288384-3122-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370288384-3122-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jun 2013, Stephen Boyd wrote:

> Use devm_ioremap_resource and devm_kzalloc to simplify error
> paths and reduce lines of code. Also use dev_err() to keep
> consistency and drop the .remove function because the devm
> functions take care of what it's doing besides the now obsolete
> platform_set_drvdata() which we can just drop. Finally, use
> module_platform_driver() to save some more lines.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Really nice.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
