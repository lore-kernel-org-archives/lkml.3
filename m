Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaDDSPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:15:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaDDSPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:15:34 -0400
Message-ID: <533EF6C5.3040301@codeaurora.org>
Date: Fri, 04 Apr 2014 11:15:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Mike Turquette <mturquette@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Add basic support for APQ8064 global clock
 controller clocks
References: <1396629089-7358-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396629089-7358-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 09:31, Kumar Gala wrote:
> The APQ8064 and MSM8960 share a significant amount of clock data and
> code between the two SoCs.  Rather than duplicating the data we just add
> support for a unqiue APQ8064 clock table into the MSM8960 code.
>
> For now add just enough clocks to get a basic serial port going on an
> APQ8064 device.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>


Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

