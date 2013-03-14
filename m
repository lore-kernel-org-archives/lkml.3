Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3CNNCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:02:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35448 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3CNNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:02:14 -0400
Message-ID: <5141CA40.9010005@ti.com>
Date: Thu, 14 Mar 2013 18:31:52 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>
Subject: Re: [PATCH 2/3] ARM: davinci: da850: Enable EHRPWM TBCLK from CFG_CHIP1
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com> <1363257453-24747-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363257453-24747-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2013 4:07 PM, Philip Avinash wrote:
> da850 platforms require TBCLK synchronization in CFG_CHIP1 register for
> TBCLK enable in EHRPWM modules. Enabling of TBCLK is done only if EHRPWM
> DT node status is set to "okay" DT blob.
> Also adds macro definitions for DA8XX_EHRPWM_TBCLKSYNC and
> DA8XX_CFGCHIP1_REG.

So there is actually a TBCLK in DA850 - it's just not modeled as a clock
similar to the way it is done on AM335x? If yes, then instead of adding
a dummy clock node and doing the TBCLK enable as part of init, why not
model TBCLK in clock tree even on DA850?

Thanks,
Sekhar
