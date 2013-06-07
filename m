Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3FGQHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:07:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13066 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3FGQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:07:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 07 Jun 2013 09:06:53 -0700
Message-ID: <51B2054B.7030609@nvidia.com>
Date: Fri, 7 Jun 2013 12:07:39 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>
CC: "cbou@mail.ru" <cbou@mail.ru>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] tps65090-charger: Fix AC detect
References: <1370553163-31804-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1370553163-31804-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2013 5:12 PM, Andrew Chew wrote:
> The VACG interrupt was not being enabled.  Thus, interrupts were never
> generated when AC status changes.  In addition, interrupts were never
> cleared after taking and processing the interrupt.
> 
> Added the register offset for the INTR_MASK register, since this is needed
> to unmask the VACG interrupt.
> 
> Enabled the VACG interrupt in tps65090_config_charger().
> 
> Cleared interrupts after processing, in tps65090_charger_isr().
> 
> Also removed unused variable "enable" in tps65090_enable_charging(),
> and fixed a typo in one of the dev_err() prints.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---

Great! Tested and it works great on my Dalmore.

Tested-by: Rhyland Klein <rklein@nvidia.com>
Acked-by: Rhyland Klein <rklein@nvidia.com>

-rhyland

-- 
nvpublic
