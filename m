Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaIYWBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:01:45 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48215 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaIYWBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:01:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kever Yang <kever.yang@rock-chips.com>, heiko@sntech.de
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1411565795-26966-1-git-send-email-kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        "Kever Yang" <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        "Kumar Gala" <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <1411565795-26966-1-git-send-email-kever.yang@rock-chips.com>
Message-ID: <20140925220119.19023.81611@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 0/2] Add clock binding id for rk3288
Date: Thu, 25 Sep 2014 15:01:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kever Yang (2014-09-24 06:36:33)
> This patch add some clock binding id for different modules
> that under development and going to send upstream.
> 
> This patch also add the clock node in PD_VIDEO.

Applied both patches to clk-next and fixed up the comment block locally.

Regards,
Mike

> 
> 
> Kever Yang (2):
>   clk: rockchip: add some needed clock binding id for rk3288
>   clk: rockchip: use the clock id for nodes init
> 
>  drivers/clk/rockchip/clk-rk3288.c      | 79 +++++++++++++++++++---------------
>  include/dt-bindings/clock/rk3288-cru.h | 38 +++++++++++++++-
>  2 files changed, 82 insertions(+), 35 deletions(-)
> 
> -- 
> 1.9.1
> 
