Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaHGS10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:27:26 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:40036 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaHGS1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:27:24 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>
CC: "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Topic: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Index: AQHPsiLtn9dZ0AQL7EiI6xLR7fBZd5vFdFmA
Date: Thu, 7 Aug 2014 18:26:02 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
 <1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kever Yang [mailto:kever.yang@gmail.com] On Behalf Of Kever Yang
> Sent: Thursday, August 07, 2014 2:35 AM
> 
> This patch add compatible data for dwc2 controller found on
> rk3066, rk3188 and rk3288 processors from rockchip.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> 
> Changes in v4:
> - max_transfer_size change to 65536, this should be enough
>   for most transfer, the hardware auto-detect will set this
>   to 0x7ffff which may make dma_alloc_coherent fail when
>   non-dword aligned buf from driver like usbnet happen.

Hi Kever,

Did you test this change thoroughly? I have vague memories of any
value above 65535 causing problems, at least on my hardware. And I
see it is set to 65535 in both pci.c and platform.c. I could be
wrong, but I thought I should mention it.

-- 
Paul

