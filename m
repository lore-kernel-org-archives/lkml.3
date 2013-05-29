Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345Ab3E2SPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:15:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46705 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab3E2SPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:15:48 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 14:15:48 EDT
Message-ID: <51A64453.5040005@codeaurora.org>
Date: Wed, 29 May 2013 14:09:23 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux@arm.linux.org.uk,
        Ian.Campbell@citrix.com, arnd@arndb.de, marc.zyngier@arm.com,
        konrad.wilk@oracle.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, nico@linaro.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/4] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
References: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com> <1369763672-12919-3-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1369763672-12919-3-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 05/28/2013 01:54 PM, Stefano Stabellini wrote:
> Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.
> 
> The only paravirt interface supported is pv_time_ops.steal_clock, so no
> runtime pvops patching needed.
> 
> This allows us to make use of steal_account_process_tick for stolen
> ticks accounting.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com
> CC: nico@linaro.org
> CC: marc.zyngier@arm.com
> CC: cov@codeaurora.org
> CC: arnd@arndb.de
> CC: olof@lixom.net
> 
> Changes in v3:
> - improve commit description and Kconfig help text;
> - no need to initialize pv_time_ops;
> - add PARAVIRT_TIME_ACCOUNTING.

Looks good to me.

Acked-by: Christopher Covington <cov@codeaurora.org>

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
