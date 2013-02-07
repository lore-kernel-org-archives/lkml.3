Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649Ab3BGTjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:39:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42115 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422629Ab3BGTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:39:44 -0500
Message-ID: <511402FC.50807@wwwdotorg.org>
Date: Thu, 07 Feb 2013 12:39:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Hiroshi Doyu <hdoyu@nvidia.com>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 4/4] clocksource: tegra20: use the device_node pointer
 passed to init
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360264144-20714-5-git-send-email-robherring2@gmail.com>
In-Reply-To: <1360264144-20714-5-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 12:09 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> We've already matched the node, so use the node pointer passed in. The rtc
> init was intermingled with the timer init, so split this out to a separate
> init function.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

Patches 1,4:
Tested-by: Stephen Warren <swarren@nvidia.com>

One thing I wonder re: patch 4 - I know someone (I think Hiroshi, now
CC'd) planned to refactor drivers/clocksource/tegra20_timer.c to enhance
it for Tegra114. I'd like to check with him that the refactoring in this
patch won't impede that at all.
