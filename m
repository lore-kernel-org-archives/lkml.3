Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaE0Sn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:43:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48861 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0Snz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:43:55 -0400
Date: Tue, 27 May 2014 11:44:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: msm: Silence readb/writeb warnings due to
 missing IOMEM()
Message-ID: <20140527184406.GA27420@quad.lixom.net>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
 <1393467394-10907-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393467394-10907-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:16:33PM -0800, Stephen Boyd wrote:
> TROUT_CPLD_BASE needs the IOMEM() treatment to avoid warnings
> from the read/writeb functions.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/board-trout-gpio.c | 2 +-
>  arch/arm/mach-msm/board-trout.c      | 2 +-
>  arch/arm/mach-msm/board-trout.h      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Applied to next/fixes-non-critical.


-Olof
