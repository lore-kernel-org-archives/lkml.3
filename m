Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbaLKHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:16:27 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:53057 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbaLKHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:16:25 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: devicetree@vger.kernel.org
X-SENDER-IP: 104.167.231.143
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <641464a2dff2d863c1e5b6b6b69c355e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548944B6.90703@rock-chips.com>
Date: Thu, 11 Dec 2014 15:16:06 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Yunzhi Li <lyz@rock-chips.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, heiko@sntech.de,
        jwerner@chromium.org, dianders@chromium.org, olof@lixom.net,
        huangtao@rock-chips.com, cf@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com>	 <1418208371-18851-2-git-send-email-lyz@rock-chips.com>	 <5489338C.1030109@ti.com> <1418278322.18092.30.camel@perches.com>	 <54893963.7060304@ti.com> <1418279847.18092.32.camel@perches.com>	 <54893F26.5050304@rock-chips.com> <1418281568.18092.34.camel@perches.com>
In-Reply-To: <1418281568.18092.34.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/11/2014 03:06 PM, Joe Perches wrote:
> On Thu, 2014-12-11 at 14:52 +0800, Yunzhi Li wrote:
>> On 2014/12/11 14:37, Joe Perches wrote:
>>> On Thu, 2014-12-11 at 11:57 +0530, Kishon Vijay Abraham I wrote:
> []
>>>> So If I have to write something on bit 0, I have to set bit 16.
>>>> If I have to write something on bit 1, I have to set bit 17.
>>>> If I have to write something on bit 2, I have to set bit 18.
>>>> and so on.
>>> To me it'd look better to use another << rather than a plus
>> Like (BIT(13) << 16)? It looks strange, or could I just use ((1 << 13)
>> << 16) to describe this bit ?
> Up to you.  To me, the BIT(x+y) seems odd.
I think BIT(29) is better, since you have described in comments.
>
>
>
>
>


