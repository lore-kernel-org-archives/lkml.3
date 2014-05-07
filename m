Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaEGKi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:38:57 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59067 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <53675D72.70103@ti.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
	<1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
	<534506B1.4040908@samsung.com>
	<CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
	<53451A60.4050803@samsung.com>
	<53675D72.70103@ti.com>
Date: Wed, 7 May 2014 16:08:53 +0530
X-Google-Sender-Auth: klCFvpTwbmmcEBf5bBwZpClB2gI
Message-ID: <CAPdUM4N+2VXpiFSiWW9gKfbte1zkpDbCOSF+KvEo4T1KLqqwjw@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 May 2014 15:14, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 09 April 2014 03:31 PM, Sylwester Nawrocki wrote:
>> Hi,
>>
>> On 09/04/14 11:12, Rahul Sharma wrote:
>>> Idea looks good. How about keeping compatible which is independent
>>> of SoC, something like "samsung,exynos-simple-phy" and provide Reg
>>> and Bit through phy provider node. This way we can avoid SoC specific
>>> hardcoding in phy driver and don't need to look into dt bindings for
>>> each new SoC.
>>
>> I believe it is a not recommended approach.
>
> Why not? We should try to avoid hard coding in the driver code. Moreover by
> avoiding hardcoding we can make it a generic driver for single bit PHYs.
>

+1.

@Tomasz, any plans to consider this approach for simple phy driver?

Regards,
Rahul Sharma.

> Cheers
> Kishon
