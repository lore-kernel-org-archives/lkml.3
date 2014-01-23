Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaAWT7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:59:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46267 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaAWT7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:59:34 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 0/2] Enable clock controllers on MSM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <878uu6y5im.fsf@paris.lan>
Date: Thu, 23 Jan 2014 13:59:28 -0600
Cc: Stephen Boyd <sboyd@codeaurora.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DBC6E587-D188-4DA7-B898-D1DF34613320@codeaurora.org>
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org> <878uu6y5im.fsf@paris.lan>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2014, at 11:25 AM, Kevin Hilman <khilman@linaro.org> wrote:

> Stephen Boyd <sboyd@codeaurora.org> writes:
> 
>> These patches add the clock controller nodes, enable the clock drivers
>> on MSM based platforms, and hook it up enough to get the serial console
>> working. This is based on the merge of Mike's clk-next branch with
>> linux-next-20140116. The changes need the clk-next branch because that's
>> where the DTS include files landed.
> 
> I forgot to repond to this earlier, but I tested this on top of -next
> and it gets the dragonboard booting w/mainline.  Yay!
> 
>> Perhaps this can be applied after 3.14-rc1 is out?
> 
> Yeah, sounds good.
> 
> Kevin

We’ll need arm-soc to pull in the clk changes from Mike’s tree for that.

> Stephen Boyd (2):
>>  ARM: dts: msm: Add clock controller nodes and hook into uart
>>  ARM: msm_defconfig: Enable MSM clock drivers
>> 
>> arch/arm/boot/dts/qcom-msm8660-surf.dts | 11 +++++++++++
>> arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 18 ++++++++++++++++++
>> arch/arm/boot/dts/qcom-msm8974.dtsi     | 24 ++++++++++++++++++++++++
>> arch/arm/configs/msm_defconfig          |  4 ++++
>> 4 files changed, 57 insertions(+)

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

