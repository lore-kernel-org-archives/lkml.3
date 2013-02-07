Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3BGUF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:05:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16659 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab3BGUF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:05:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 07 Feb 2013 12:05:10 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: "robherring2@gmail.com" <robherring2@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>
Date: Thu, 7 Feb 2013 21:05:04 +0100
Subject: Re: [PATCH 4/4] clocksource: tegra20: use the device_node pointer
 passed to init
Thread-Topic: [PATCH 4/4] clocksource: tegra20: use the device_node pointer
 passed to init
Thread-Index: Ac4FbmzDM36UzoljRQOZHtHRHvv9Gg==
Message-ID: <20130207.220504.79003148683176035.hdoyu@nvidia.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com><1360264144-20714-5-git-send-email-robherring2@gmail.com><511402FC.50807@wwwdotorg.org>
In-Reply-To: <511402FC.50807@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Thu, 7 Feb 2013 20:39:40 +0100:

> On 02/07/2013 12:09 PM, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > We've already matched the node, so use the node pointer passed in. The rtc
> > init was intermingled with the timer init, so split this out to a separate
> > init function.
> 
> The series,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> 
> Patches 1,4:
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> One thing I wonder re: patch 4 - I know someone (I think Hiroshi, now
> CC'd) planned to refactor drivers/clocksource/tegra20_timer.c to enhance
> it for Tegra114. I'd like to check with him that the refactoring in this
> patch won't impede that at all.

Actually this covers RTC part. I'll rework mine for the rest on the
top of this.
