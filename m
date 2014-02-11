Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBKKUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:20:22 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52797 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaBKKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:20:17 -0500
Message-ID: <52F9F958.5010904@st.com>
Date: Tue, 11 Feb 2014 11:20:08 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <maxime.coquelin@st.com>
Subject: Re: [PATCH 0/3] CCF clock divider changes
References: <1391012648-12481-1-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1391012648-12481-1-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

	Did you have a look at this series?

	If patch 1 gets accepted, should it also be submitted to the stable 
branches?

Thanks,
Maxime

On 01/29/2014 05:24 PM, Maxime COQUELIN wrote:
> Hi Mike,
>
> First patch fixes round_rate for power-of-two and table-based dividers when
> the CLK_SET_RATE_PARENT flag isn't set.
>
> Second patch introduces a new flag to give the possibility to round the
> divider to the closest one, instead of rounding up by default.
>
> Third patch optimizes the for-loop when CLK_SET_RATE_PARENT is set for
> power-of-two and table-based dividers.
>
> The series applies on top of v3.13 tag.
>
> Maxime Coquelin (3):
>    clk: divider: Fix best div calculation for power-of-two and table
>      dividers
>    clk: divider: Add round to closest divider
>    clk: divider: Optimize clk_divider_bestdiv loop
>
>   drivers/clk/clk-divider.c    |  118 ++++++++++++++++++++++++++++++++++++++++--
>   include/linux/clk-provider.h |    3 ++
>   2 files changed, 118 insertions(+), 3 deletions(-)
>
