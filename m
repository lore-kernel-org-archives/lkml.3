Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaJGRL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:11:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:64634 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJGRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com>
References: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 7 Oct 2014 10:11:54 -0700
X-Google-Sender-Auth: vbbxUZzKFTzfaJdjtKf-0Tvgfxw
Message-ID: <CAD=FV=URpegr4xZ8fVf4AmKYWg2_UtS-nsQibuaXddio3xMNig@mail.gmail.com>
Subject: Re: [PATCH 0/2] init some clock rate from dts for rk3288
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Tue, Oct 7, 2014 at 2:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add init rate for PLLs and some bus clock  from dts for rk3288,
> add two clock rate of 400M and 500M into rate table for we will use it.

In the cover letter you should probably mention that your series won't
work properly unless <https://patchwork.kernel.org/patch/5038781/> is
applied.  When I don't have that patch then "aclk_cpu" doesn't get set
properly.
