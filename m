Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaAKF17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 00:27:59 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46247 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaAKF15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 00:27:57 -0500
MIME-Version: 1.0
In-Reply-To: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
References: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 11 Jan 2014 13:27:36 +0800
Message-ID: <CAGsJ_4wxBak6aL-G_YsGe7_r1yaH927_jUvGeBBdfaSZ0HaYag@mail.gmail.com>
Subject: Re: [PATCH v2] clk: sirf: re-arch to make the codes support both
 prima2 and atlas6
To: Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <Baohua.Song@csr.com>, Rongjun Ying <Rongjun.Ying@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/6 Barry Song <21cnbao@gmail.com>:
> From: Barry Song <Baohua.Song@csr.com>
>
> sirfprima2 and sirfatlas6 are two different SoCs in CSR SiRF series. for
> prima2 and atlas6, there are many shared clocks but there are still
> some different register layout and hardware clocks, then result in
> different clock table.
>
> here we re-arch the driver to
> 1. clk-common.c provides common clocks for prima2 and atlas6,
> 2. clk-prima2.h describles registers of prima2 and clk-prima2.c provides
> prima2 specific clocks and clock table.
> 3. clk-atlas6.h describles registers of atlas6 and clk-atlas6.c provides
> atlas6 specific clocks and clock table.
> 4. clk.h and clk.c expose external interfaces and provide uniform entry
> for both prima2 and atlas6.
>
> so both prima2 and atlas6 will get support by drivers/clk/sirf.
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> Signed-off-by: Rongjun Ying <Rongjun.Ying@csr.com>
> ---
>  -v2:
>  rebase to 3.13-rc;
>  use CLK_OF_DECLARE and make init function static

Hi Mike,
any feedback for this? i sent v1 some time ago and didn't get your
answer. and here it has been v2.

-barry
