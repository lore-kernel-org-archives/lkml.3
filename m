Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaAHTNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:13:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36616 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHTNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:13:21 -0500
Message-ID: <52CDA34C.2030605@codeaurora.org>
Date: Wed, 08 Jan 2014 14:13:16 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux@arm.linux.org.uk,
        Ian.Campbell@citrix.com, arnd@arndb.de, marc.zyngier@arm.com,
        Catalin.Marinas@arm.com, konrad.wilk@oracle.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, nico@linaro.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 4/6] arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com> <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 01/08/2014 01:49 PM, Stefano Stabellini wrote:
> Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM64.
> Necessary duplication of paravirt.h and paravirt.c with ARM.
> 
> The only paravirt interface supported is pv_time_ops.steal_clock, so no
> runtime pvops patching needed.
> 
> This allows us to make use of steal_account_process_tick for stolen
> ticks accounting.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: nico@linaro.org
> CC: marc.zyngier@arm.com
> CC: cov@codeaurora.org
> CC: arnd@arndb.de
> CC: olof@lixom.net
> CC: Catalin.Marinas@arm.com

Looks good to me.

Acked-by Christopher Covington <cov@codeaurora.org>

While I don't think it should necessarily gate these changes, I wonder if at
some point the config options could be consolidated across the various
architectures using them.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
