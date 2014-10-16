Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaJPDlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:41:15 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:51997 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaJPDlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <1413406225-16366-1-git-send-email-zyw@rock-chips.com>
References: <1413405987-16196-1-git-send-email-zyw@rock-chips.com>
	<1413406225-16366-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 15 Oct 2014 20:41:11 -0700
X-Google-Sender-Auth: jMdZ2DrzG1UJZgT_h-NAZGnBzXs
Message-ID: <CAD=FV=V4LrUxLRoMA4neUdA7Xq+mvQwF9MeMtoJ03t0Gjm+R1A@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: rockchip: add pmu-sram sub
From: Doug Anderson <dianders@chromium.org>
To: Chris <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Oct 15, 2014 at 1:50 PM,  <zyw@rock-chips.com> wrote:
> From: Chris Zhong <zyw@rock-chips.com>
>
> The pmu-sram is used to store resume code, suspend/resume need get the
> address of it. Therefore add a node and documentation for it.

This patch just adds bindings, not a node.

>
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
>  .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt

Title of this patch should probably mention bindings somewhere.  Also
bindings should be patch #3 and the adding to the DTS patch #4.
