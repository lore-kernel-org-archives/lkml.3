Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaHHPm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:42:57 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63940 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaHHPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <1407470159-14722-3-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
	<1407470159-14722-3-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 8 Aug 2014 08:42:54 -0700
X-Google-Sender-Auth: Q0GOsucr418YhYfMhlBScyk8u9s
Message-ID: <CAD=FV=WaiL9w7X1qcvfZ2K+su-VDnWhE+YnEeyWWt=mTtZss7Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] usb: dwc2: add compatible data for rockchip soc
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever

On Thu, Aug 7, 2014 at 8:55 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add compatible data for dwc2 controller found on
> rk3066, rk3188 and rk3288 processors from rockchip.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>
> Changes in v5:
> - max_transfer_size change to 65535 to met the requirement of
>   header file
>
> Changes in v4:
> - max_transfer_size change to 65536, this should be enough
>   for most transfer, the hardware auto-detect will set this
>   to 0x7ffff which may make dma_alloc_coherent fail when
>   non-dword aligned buf from driver like usbnet happen.
>
> Changes in v3: None
> Changes in v2:
> - set most parameters as driver auto-detect
>
>  drivers/usb/dwc2/platform.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)

IMHO this series is ready to go in for 3.18 whenever maintainers feel
it's the right time.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
