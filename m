Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaLVRGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:06:54 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61052 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaLVRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <1419244588-5227-2-git-send-email-wulf@rock-chips.com>
References: <1419244588-5227-1-git-send-email-wulf@rock-chips.com>
	<1419244588-5227-2-git-send-email-wulf@rock-chips.com>
Date: Mon, 22 Dec 2014 09:06:51 -0800
Message-ID: <CAD=FV=WF1uRnJu5cqE1y_CDMLMtV7ha5cV51UGJRO3d-78Jsiw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: usb-ehci: Add an optional property "needs-reset-on-resume"
From: Doug Anderson <dianders@google.com>
To: Wu Liang feng <wulf@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Julius Werner <jwerner@google.com>,
        Pawel Osciak <posciak@google.com>, Tomasz Figa <tfiga@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Liang feng,

On Mon, Dec 22, 2014 at 2:36 AM, Wu Liang feng <wulf@rock-chips.com> wrote:
> Add device-tree bindings for EHCI so we can use "needs-reset-on-resume"
> property to force EHCI reset after resume if necessary. This is necessary
> on platforms like rk3288 that need a reset after resume to detect if a
> device has been disconnected during suspend time.
>
> Signed-off-by: Wu Liang feng <wulf@rock-chips.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-ehci.txt | 1 +
>  1 file changed, 1 insertion(+)

It may not count for much given my lack of experience with the USB
subsystem, but I'll give it anyway:

Reviewed-by: Doug Anderson <dianders@chromium.org>

-Doug
