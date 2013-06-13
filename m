Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3FMGEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:04:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49867 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3FMGEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:04:12 -0400
Message-ID: <51B960D6.7080901@linaro.org>
Date: Thu, 13 Jun 2013 11:34:06 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com
CC: arnd@arndb.de, olof@lixom.net, patches@linaro.org
Subject: Re: [PATCH v2 2/3] ARM: SAMSUNG: Consolidate uncompress subroutine
References: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org> <1370319552-17694-3-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370319552-17694-3-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:49 AM, Tushar Behera wrote:
> For mach-exynos, uart_base is a pointer and the value is calculated
> in the machine folder. For other machines, uart_base is defined as
> a macro in platform directory. For symmetry, the uart_base macro
> definition is removed and the uart_base calculation is moved to
> specific machine folders.
> 
> This would help us consolidating uncompress subroutine for s5p64x0.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Changes for v2:
> * Remove ifdef's while calculating uart_base value.
> 

Kukjin,

Would you please queue this up for 3.11?

Thanks.

-- 
Tushar Behera
