Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaGVKMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:12:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaGVKMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:12:34 -0400
Message-ID: <53CE38DF.1060305@ti.com>
Date: Tue, 22 Jul 2014 15:41:43 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and
 CPSW
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com> <20140717074948.GF18374@atomide.com>
In-Reply-To: <20140717074948.GF18374@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 01:19 PM, Tony Lindgren wrote:
> We seem to have this layout WR_SOFT_RESET and WR_CONTROL in the TRM:
>
> WR_SOFT_RESET
> [0]     SOFT_RESET
>
> WR_CONTROL
> [3:2]   MMR_STDBYMODE   0 = force-idle, 1 = no-standby
> [1:0]   MMR_IDLEMODE    0 = force-idle, 1 = no-idle
>
> And so it seems to match what am33xx also has for am33xx_cpgmac_sysc
> and am33xx TRM for 14.5.9 CONTROL register. So as far as I'm concerned:
>
> Acked-by: Tony Lindgren <tony@atomide.com>
Paul,

Can you pull this patch as Tony acked the patch.

Regards
Mugunthan V N
