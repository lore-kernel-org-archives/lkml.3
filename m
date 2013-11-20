Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3KTOve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:51:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40591 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3KTOvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:51:32 -0500
Message-ID: <528CCC5B.4010204@ti.com>
Date: Wed, 20 Nov 2013 09:51:07 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: keystone: gate: fix error handling on init
References: <1384949341-26486-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1384949341-26486-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013 07:09 AM, Grygorii Strashko wrote:
> This patch fixes Keystone gate control clock driver initialization path:
> 1) clk_register_psc() returns error code and not a pure pointer, hence
> its return value need to be checked using IS_ERR(clk) macro.
> 
> 2) Mapped IO memory isn't unmapped in case of errors, hence fix it.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
Looks good. Thanks !!

Mike, If you are ok can you please consider it for fixes ?

Regards,
Santosh
