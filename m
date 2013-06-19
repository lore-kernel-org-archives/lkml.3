Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3FSH6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:58:46 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56592 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab3FSH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:58:45 -0400
Date: Wed, 19 Jun 2013 08:58:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: Re: [PATCH 2/2] mfd: davinci_voicecodec: Convert to use devm_* APIs
Message-ID: <20130619075839.GF31320@laptop>
References: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
 <1371549940-18834-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371549940-18834-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Sachin Kamat wrote:

> devm_* APIs are device managed and make code simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> ---
>  drivers/mfd/davinci_voicecodec.c       |   48 +++++++-------------------------
>  include/linux/mfd/davinci_voicecodec.h |    2 --
>  2 files changed, 10 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
