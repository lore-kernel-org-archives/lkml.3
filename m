Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbaGOIjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:39:19 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45174 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbaGOIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:39:16 -0400
Message-ID: <53C4E8B1.3040305@linaro.org>
Date: Tue, 15 Jul 2014 09:39:13 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 0/2] Support apq8064 global clock control
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org> <1404980193-5967-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1404980193-5967-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Could you please consider these patches for v3.17 as some of the drivers 
which require these clocks are already making there way to 3.17.


Thanks,
srini

On 10/07/14 09:16, Srinivas Kandagatla wrote:
> These two patches add full support for apq8064 in the global clock
> controller driver. The first patch has already been on the list so
> I've picked it up and resent because the second patch depends on it.
>
> Am resending the series with the fix to my patch.
>
> Changes since v1:
> 	- fixed comment log spotted by Andreas.
> 	- added few more sdcc clocks.
>
> Srinivas Kandagatla (1):
>    clk: qcom: add clocks necessary for apq8064 sdcc
>
> Stephen Boyd (1):
>    clk: qcom: Fully support apq8064 global clock control
>
>   drivers/clk/qcom/gcc-msm8960.c               | 583 ++++++++++++++++++++++++++-
>   include/dt-bindings/clock/qcom,gcc-msm8960.h |  11 +
>   include/dt-bindings/reset/qcom,gcc-msm8960.h |  16 +
>   3 files changed, 607 insertions(+), 3 deletions(-)
>
