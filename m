Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3KHN7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:59:22 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59651 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KHN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131108123619.GC31551@ulmo.nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
 <CAH9NwWfDRiQ3FegMyx1YBQ5jUgPvc7h2cxd3KgyeDdnsq6UgMw@mail.gmail.com> <20131108123619.GC31551@ulmo.nvidia.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Fri, 8 Nov 2013 14:58:56 +0100
Message-ID: <CAH9NwWc0AjmnXX1uen1z1bX5Z0pRyYrGY9a949L6=ZAF6YeL8w@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] pwm-backlight: Add GPIO and power supply support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/8 Thierry Reding <thierry.reding@gmail.com>:
> On Thu, Nov 07, 2013 at 01:00:04PM +0100, Christian Gmeiner wrote:
>> Hi Thierry
>>
>>
>> This series adds the ability to specify a GPIO and a power supply to
>> > enable a backlight.
>> >
>>
>> Whats the state of this patch set? I am looking for this kind of
>> functionality for a pwm based
>> backlight on a devicetree only imx6 device.
>
> Those patches (except the one that adds the backlight-boot-off property)
> will be part of my pull request for 3.13.
>

That are really good news.. will try this patch set on a 3.12 kernel.

--
Christian Gmeiner, MSc
