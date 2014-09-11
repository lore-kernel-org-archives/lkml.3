Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaIKRlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:41:06 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46438 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaIKRlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <1410343554-8383-2-git-send-email-kever.yang@rock-chips.com>
References: <1410343554-8383-1-git-send-email-kever.yang@rock-chips.com>
	<1410343554-8383-2-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 11 Sep 2014 10:41:02 -0700
X-Google-Sender-Auth: Hy_IJ3fqANwk4nCN-pyS2ePi0BU
Message-ID: <CAD=FV=UafRXZ=qHbTdsg88ZwWO-1qPA7ERvCN8321GcjybYUiA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: rockchip: add basic smp support for rk3288
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Sep 10, 2014 at 3:05 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> -CPU_METHOD_OF_DECLARE(rk3066_smp, "rockchip,rk3066-smp", &rockchip_smp_ops);
> +CPU_METHOD_OF_DECLARE(rk3288_smp, "rockchip,rk3288-smp", &rockchip3288_smp_ops);

I haven't done a full review, but I think that the above means you
need to update "Documentation/devicetree/bindings/arm/cpus.txt".

-Doug
