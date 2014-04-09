Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbaDIKqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:46:36 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63658 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDIKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <53452157.9030203@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
	<1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
	<53452157.9030203@samsung.com>
Date: Wed, 9 Apr 2014 16:16:31 +0530
Message-ID: <CAPdUM4NhP-gcA2CYVEYBzEPztSozmFKjB8X9ep-_MNE7q+ZhkQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] drm: exynos: hdmi: use hdmiphy as PHY
From: Rahul Sharma <r.sh.open@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 9 April 2014 16:00, Andrzej Hajda <a.hajda@samsung.com> wrote:
> Hi Tomasz,
>
> On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
>> The HDMIPHY (physical interface) is controlled by a single
>> bit in a power controller's regiter. It was implemented
>> as clock. It was a simple but effective hack.
>
> This power controller register has also bits to control HDMI clock
> divider ratio. I guess current drivers do not change it, but how do you
> want to implement access to it if some HDMI driver in the future will
> need to change ratio. I guess in case of clk it would be easier.

If it is really required to change this divider, it should be registered as
a clock provider in clock driver exposing single divider clock.

Regards,
Rahul Sharma

>
> Regards
> Andrzej
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
