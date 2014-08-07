Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaHGDeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:34:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37926 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbaHGDeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <1407286910-30906-3-git-send-email-kever.yang@rock-chips.com>
References: <1407286910-30906-1-git-send-email-kever.yang@rock-chips.com>
	<1407286910-30906-3-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 6 Aug 2014 20:34:07 -0700
X-Google-Sender-Auth: RziHHq-dvfAoStd5VIjkWgGmDMM
Message-ID: <CAD=FV=VG4qqXTPe1ZYZ56KDrntiZiU20Ne8Ng9BqtyER0vt1Og@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] usb: dwc2: add 'mode' which based on Kconfig
 select or dts setting
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, Jingoo Han <jg1.han@samsung.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Tue, Aug 5, 2014 at 6:01 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> According to the "dr_mode", the otg controller can work as
> device role and host role. Some boards always want to use host mode
> and some other boards want to use gadget mode. We use the dts setting
> to set dwc2's mode, rather than fixing it to whatever hardware says.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>
> Changes in v4:
> - From Doug's suggestion:
>  -- remove dr_mode init from Kconfig code
>  -- change the commit meesage
>
> Changes in v3:
> - fix the odd spacing in dwc2_hsotg struct
> - From Jingoo's suggestion:
>     change the commit message
> - add dr_mode init from Kconfig
>
> Changes in v2:
> - put spaces around '+' operator
> - expand the comment for dr_mode
> - handle dr_mode is USB_DR_MODE_OTG
>
>  drivers/usb/dwc2/core.c     | 18 ++++++++++++++++++
>  drivers/usb/dwc2/core.h     |  5 +++++
>  drivers/usb/dwc2/platform.c |  4 ++++
>  3 files changed, 27 insertions(+)

I don't know the driver well enough to feel like I can add my
Reviewed-by tag, but since you've already got an Ack from Paul it
doesn't matter much.  ...FWIW I'm happy with the current state of the
code now.  :)

-Doug
