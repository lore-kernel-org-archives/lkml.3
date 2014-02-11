Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBKJ0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:26:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41777 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaBKJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:26:34 -0500
Message-ID: <52F9ECC7.8010702@linaro.org>
Date: Tue, 11 Feb 2014 10:26:31 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] clocksource: qcom: Move clocksource code out of mach-msm
References: <1391553421-26914-1-git-send-email-galak@codeaurora.org> <1391553421-26914-3-git-send-email-galak@codeaurora.org>
In-Reply-To: <1391553421-26914-3-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 11:36 PM, Kumar Gala wrote:
> We intent to share the clocksource code for MSM platforms between legacy
> and multiplatform supported qcom SoCs.
>
> Acked-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Hi Kumar,

through which tree do you expect this patch to be upstream ?



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

