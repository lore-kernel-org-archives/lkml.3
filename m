Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaEPObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:31:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaEPObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:31:11 -0400
Message-ID: <5376212D.4080701@codeaurora.org>
Date: Fri, 16 May 2014 07:31:09 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: daniel.lezcano@linaro.org, tglx@linutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com> <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/14 19:18, Xiubo Li wrote:
> +bool big_endian;
> +

static?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

