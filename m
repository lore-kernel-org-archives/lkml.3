Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaLHN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:57:23 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59230 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLHN5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:57:21 -0500
Date: Mon, 8 Dec 2014 13:57:16 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        kernel@stlinux.com
Subject: Re: [STLinux Kernel] [PATCH v2 RESEND 02/11] mtd: st_spi_fsm: Obtain
 and use EMI clock if provided
Message-ID: <20141208135716.GC29220@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
 <1417688512-7644-3-git-send-email-lee.jones@linaro.org>
 <20141208135223.GB29220@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208135223.GB29220@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> On Thu, 04 Dec 2014, Lee Jones wrote:
> 
> > ST's Common Clk Framework is now available. This patch ensures the FSM
> > makes use of it by obtaining and enabling the EMI clock if provided. If
> > system fails to provide the EMI clock FSM uses its original default
> > rate.
> 
> <snip>
> 
> I'm not sure I understand this patch. Now that common clock framework
> is available for STI platforms, why would the emi clock ever not be available?
> 
> If it is to maintain DT compatability then we are already breaking this with the
> syscfg 'reg' DT changes which are coming up, and this was deemed OK as the platform
> is WIP.
> 
> IMO keeping this legacy code which assumes the bootloader / JTAG has enabled and configured
> the emi clock correctly is not worth it now that CCF is available for the platform.

Also this legacy code will definately break when we we stop booting the kernel with
"clk_ignore_unused" parameter.

regards,

Peter.
