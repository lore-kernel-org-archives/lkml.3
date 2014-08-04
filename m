Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaHDQUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:48 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:54717 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaHDQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <1407159942-7063-2-git-send-email-kever.yang@rock-chips.com>
References: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
	<1407159942-7063-2-git-send-email-kever.yang@rock-chips.com>
Date: Mon, 4 Aug 2014 09:20:42 -0700
X-Google-Sender-Auth: 9IvHlW1cD1BVIxRTx3v50I7a5K0
Message-ID: <CAD=FV=Vi07yrO1EEGthUgN7MRV2cmpgmK3F2PrN7DxdUZgb9Sw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Documentation: dt-bindings: add dt binding info
 for dwc2 dr_mode
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@vger.kernel.org, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        wulf <wulf@rock-chips.com>, lyz <lyz@rock-chips.com>,
        Jingoo Han <jg1.han@samsung.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Felipe Balbi <balbi@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Mon, Aug 4, 2014 at 6:45 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Indicate that the generic dr_mode binding should be used for dwc2.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v3: None

Since I gave my Reviewed-by tag for v2 and you made no changes from v2
to v3, you should make sure you include my Reviewed-by tag in the new
version.

Reviewed-by: Doug Anderson <dianders@chromium.org>
