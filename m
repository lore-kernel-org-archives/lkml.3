Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaCYVXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:23:08 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36935 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaCYVXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:23:04 -0400
Message-ID: <5331F3B2.9000602@gmail.com>
Date: Tue, 25 Mar 2014 22:22:58 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v3] clk: berlin: add support for berlin plls
References: <1395775772-19685-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395775772-19685-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 08:29 PM, Alexandre Belloni wrote:
> This drivers allows to provide DT clocks for the cpu and system PLLs found on
> Marvell Berlin SoCs.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Tested on BG2 and BG2CD, therefore

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
> Changes in v3:
>  - removed empty lines a the end of the files
>  - vcodiv are now arrays filled with zeros by default
>  - use an u64 temporary variable to calculate the rate
>  - warn when refdiv or vcodiv are zero
> 
> ---
>  drivers/clk/Makefile              |   1 +
>  drivers/clk/berlin/Makefile       |   4 ++
>  drivers/clk/berlin/common.h       |  35 ++++++++++++
>  drivers/clk/berlin/pll-berlin2.c  |  40 +++++++++++++
>  drivers/clk/berlin/pll-berlin2q.c |  40 +++++++++++++
>  drivers/clk/berlin/pll.c          | 114 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 234 insertions(+)
>  create mode 100644 drivers/clk/berlin/Makefile
>  create mode 100644 drivers/clk/berlin/common.h
>  create mode 100644 drivers/clk/berlin/pll-berlin2.c
>  create mode 100644 drivers/clk/berlin/pll-berlin2q.c
>  create mode 100644 drivers/clk/berlin/pll.c

