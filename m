Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaG1Pu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:50:28 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:54505 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG1Pu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:50:27 -0400
Message-ID: <53D67135.1060801@elopez.com.ar>
Date: Mon, 28 Jul 2014 12:50:13 -0300
From: =?windows-1252?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: weiyj_lk@163.com
CC: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next] clk: sunxi: sun6i-apb0: fix sparse non static symbol
 warning
References: <1406554063-30350-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1406554063-30350-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 28/07/14 a las 10:27, weiyj_lk@163.com escibió:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fixes the following sparse warnings:
>
> drivers/clk/sunxi/clk-sun6i-apb0.c:60:27: warning:
>   symbol 'sun6i_a31_apb0_clk_dt_ids' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>


I sent patches earlier today to fix this and other sparse warnings, 
please see

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275680.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275681.html

Cheers,

Emilio
