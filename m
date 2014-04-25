Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaDYUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:54:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40862 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaDYUyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:54:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: <dinguyen@altera.com>, dinh.linux@gmail.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1398439322-30616-1-git-send-email-dinguyen@altera.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1398439322-30616-1-git-send-email-dinguyen@altera.com>
Message-ID: <20140425205403.23156.92535@quantum>
User-Agent: alot/0.3.5
Subject: Re: [GIT PULL] clk: socfpga: Clock fix for v3.15
Date: Fri, 25 Apr 2014 13:54:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting dinguyen@altera.com (2014-04-25 08:22:02)
> Hi Mike,
> 
> Please consider pulling this patch for 3.15 fixes.
> 
> Thanks,
> 
> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
> 
>   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
> 
> are available in the git repository at:
> 
>   git://git.rocketboards.org/linux-socfpga-next.git tags/socfpga-clk-fix-for-3.15
> 
> for you to fetch changes up to 812819daf3298040833b4902730821c3441bffc7:
> 
>   clk: socfpga: fix clock driver for 3.15 (2014-04-25 10:06:14 -0500)

Taken into clk-fixes.

Thanks!
Mike

> 
> ----------------------------------------------------------------
> clk: socfpga: clock fix for v3.15
> 
> Currently on 3.15-rc1, the SOCFPGA platform is unable to boot. This patch
> fixes the issue and allows the platform to boot.
> 
> ----------------------------------------------------------------
> Dinh Nguyen (1):
>       clk: socfpga: fix clock driver for 3.15
> 
>  drivers/clk/socfpga/clk-pll.c |    7 +++++++
>  drivers/clk/socfpga/clk.c     |   23 +++--------------------
>  2 files changed, 10 insertions(+), 20 deletions(-)
