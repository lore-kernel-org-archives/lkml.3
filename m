Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaHTTQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:16:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45279 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaHTTQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:16:01 -0400
Message-ID: <53F4F3F0.20107@codeaurora.org>
Date: Wed, 20 Aug 2014 12:16:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net> <alpine.LFD.2.11.1408172000460.29347@knanqh.ubzr> <20140818012512.GL12769@titan.lakedaemon.net> <alpine.LFD.2.11.1408172131550.29347@knanqh.ubzr> <20140818015430.GN12769@titan.lakedaemon.net>
In-Reply-To: <20140818015430.GN12769@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/14 18:54, Jason Cooper wrote:
>
> Stephen, is the out of tree code that triggered this bound for mainline?
>

It's bound for mainline eventually. We're actively working on enabling
more low power modes and when that happens we'll need this patch. We can
always carry this patch for now if you don't want to accept it, but I
figured getting it mainlined reduces our carrying burden and also makes
a minor improvement in sending IPIs when the BL switcher is used.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

