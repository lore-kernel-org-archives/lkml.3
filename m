Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921Ab3EBStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:49:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64248 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760862Ab3EBStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:49:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="43712634"
Message-ID: <5182B532.10607@codeaurora.org>
Date: Thu, 02 May 2013 14:49:22 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, marc.zyngier@arm.com,
        konrad.wilk@oracle.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] xen: move do_stolen_accounting to drivers/xen/time.c
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 05/01/2013 03:27 PM, Stefano Stabellini wrote:
> Move do_stolen_accounting, xen_vcpu_stolen and related functions and
> static variables to common code (drivers/xen/time.c).
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/time.c   |  127 +-------------------------------------------

In going through some of the code, it looked like there might be a few little
bits that you might be interested in pulling out of arch/ia64/xen/time.c as well.

[...]

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
