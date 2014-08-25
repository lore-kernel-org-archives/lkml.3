Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaHYNnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:43:43 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:47141 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaHYNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:43:41 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <d72468c9108fee2d2b51b0e0c09525a4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FB3D87.1080900@rock-chips.com>
Date: Mon, 25 Aug 2014 21:43:35 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v3 4/5] Regulator: RK808: Add regulator driver for RK808
References: <1408791890-17328-1-git-send-email-zyw@rock-chips.com> <20140823145737.GJ24407@sirena.org.uk>
In-Reply-To: <20140823145737.GJ24407@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2014 10:57 PM, Mark Brown wrote:
> On Sat, Aug 23, 2014 at 07:04:50PM +0800, Chris Zhong wrote:
>> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
>> The output voltages are configurable and are meant to supply power
>> to the main processor and other components
> To repeat what I said on your previous posting: this driver has already
> been applied, if there are any changes required please send incremental
> patches against what is in the tree.
I fixed it in v5.

