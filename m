Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3HSXAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:00:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41371 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3HSXAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:00:39 -0400
Message-ID: <5212A394.5020109@codeaurora.org>
Date: Mon, 19 Aug 2013 16:00:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, srinivas.kandagatla@st.com,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local> <5204C54A.9020105@st.com> <5204FA5D.3060908@linaro.org> <20130809172757.GD14845@codeaurora.org> <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local> <52090B43.9090000@codeaurora.org> <d36fc2db-1189-4c6a-9bc4-0ac2e29eaa1b@AM1EHSMHS009.ehs.local> <5209120D.1010701@linaro.org> <9b07d8a3-b650-4147-b952-9bcfc1172c51@VA3EHSMHS025.ehs.local> <5209152F.5020307@linaro.org> <86b18b0d-08e1-4899-86ea-ed22d3d36dee@DB8EHSMHS028.ehs.local>
In-Reply-To: <86b18b0d-08e1-4899-86ea-ed22d3d36dee@DB8EHSMHS028.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 10:28, Sören Brinkmann wrote:
> On Mon, Aug 12, 2013 at 07:02:39PM +0200, Daniel Lezcano wrote:
>> On 08/12/2013 06:53 PM, Sören Brinkmann wrote:
>>> It's actually present. I have a clean 3.11-rc3 and the only changes are
>>> my patch to enable the GT and Stephen's fix.
>>> The cpuidle stats show both idle states being used.
>> Ah, right. The tick_broadcast_mask is not set because the arm global
>> timer has not the CLOCK_EVT_FEAT_C3STOP feature flag set.
> Just to check in. Do you want any additional testing done? Or can I
> expect Stephens fix to get merged, so Zynq can use the GT?
>

I was curious, can you use just the first hunk of the patch that applied
to tick-broadcast.c to fix the problem? I think the answer is yes.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

