Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750896AbaGaEAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 00:00:07 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:45864 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbaGaEAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 00:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <1406766558-8156-2-git-send-email-kever.yang@rock-chips.com>
References: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
	<1406766558-8156-2-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 30 Jul 2014 21:00:02 -0700
X-Google-Sender-Auth: dQ8gcrEmd6vbtVSwaGhsGK7p-OI
Message-ID: <CAD=FV=V7h1=RkUwT9TmVaNgPLVLSp6fObCMkFqzQHMmOU35K1w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Documentation: dt-bindings: add dt binding info
 for dwc2 dr_mode
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Jul 30, 2014 at 5:29 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Indicate that the generic dr_mode binding should be used for dwc2.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - Split out dr_mode and rk3288 bindings.
>
>  Documentation/devicetree/bindings/usb/dwc2.txt |    2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
