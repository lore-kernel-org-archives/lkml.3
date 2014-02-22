Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBVSVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:21:12 -0500
Received: from void.printf.net ([89.145.121.20]:52690 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaBVSVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:21:11 -0500
From: Chris Ball <chris@printf.net>
To: <micky_ching@realsil.com.cn>
Cc: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: sdhci: add support for realtek rts5250
References: <1392979235-26664-1-git-send-email-micky_ching@realsil.com.cn>
Date: Sat, 22 Feb 2014 18:20:50 +0000
In-Reply-To: <1392979235-26664-1-git-send-email-micky_ching@realsil.com.cn>
	(micky ching's message of "Fri, 21 Feb 2014 18:40:35 +0800")
Message-ID: <86a9djvwjh.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micky,

On Fri, Feb 21 2014, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> Add support for realtek rts5250 pci card reader. The card reader have
> some problem with DDR50 mode, so add a new quirks2 for broken ddr50.
>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>

Thanks, pushed to mmc-next for 3.15.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
