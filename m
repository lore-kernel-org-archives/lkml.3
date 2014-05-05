Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaEEJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:44:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbaEEJoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:44:30 -0400
Message-ID: <53675D72.70103@ti.com>
Date: Mon, 5 May 2014 15:14:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rahul Sharma <r.sh.open@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        sunil joshi <joshi@samsung.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com> <1396967856-27470-2-git-send-email-t.stanislaws@samsung.com> <534506B1.4040908@samsung.com> <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com> <53451A60.4050803@samsung.com>
In-Reply-To: <53451A60.4050803@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 09 April 2014 03:31 PM, Sylwester Nawrocki wrote:
> Hi,
> 
> On 09/04/14 11:12, Rahul Sharma wrote:
>> Idea looks good. How about keeping compatible which is independent
>> of SoC, something like "samsung,exynos-simple-phy" and provide Reg
>> and Bit through phy provider node. This way we can avoid SoC specific
>> hardcoding in phy driver and don't need to look into dt bindings for
>> each new SoC.
> 
> I believe it is a not recommended approach.

Why not? We should try to avoid hard coding in the driver code. Moreover by
avoiding hardcoding we can make it a generic driver for single bit PHYs.

Cheers
Kishon
