Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967377Ab3DRPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:25:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17922 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966917Ab3DRPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:25:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363158000"; 
   d="scan'208";a="39587064"
Message-ID: <51701084.5050706@codeaurora.org>
Date: Thu, 18 Apr 2013 11:25:56 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: PranavkumarSawargaonkar <pranavkumar@linaro.org>
CC: kvmarm@lists.cs.columbia.edu, linaro-kernel@lists.linaro.org,
        Anup Patel <anup.patel@linaro.org>, patches@linaro.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
In-Reply-To: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranavkumar,

On 04/18/2013 01:52 AM, PranavkumarSawargaonkar wrote:
> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> 
> This patch implements early printk support for virtio-mmio console devices 
> without using any hypercalls.

Is it possible that using DCC might be an easier solution?

[...]

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
