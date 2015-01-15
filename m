Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbbAOTrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:47:04 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:34223 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbAOTrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:47:02 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, John Youn <John.Youn@synopsys.com>
CC: "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yunzhi Li <lyz@rock-chips.com>, Jingoo Han <jg1.han@samsung.com>,
        Nick Hudson <skrll@netbsd.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: update maintainer entry for dwc2 driver
Thread-Topic: [PATCH] MAINTAINERS: update maintainer entry for dwc2 driver
Thread-Index: AdAw+6OnaBlb9pj/Suy1qN4UDmXfpQAADSxA
Date: Thu, 15 Jan 2015 19:47:00 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484507C05@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-usb and linux-kernel to CC.

-- 
Paul

> -----Original Message-----
> From: Paul Zimmerman
> Sent: Thursday, January 15, 2015 11:44 AM
> To: gregkh@linuxfoundation.org; balbi@ti.com; John Youn (johnyoun@synopsys.com)
> Cc: 'r.baldyga@samsung.com'; 'dinguyen@opensource.altera.com'; 'Kever Yang'; 'Mian Yousaf Kaukab';
> 'Marek Szyprowski'; 'Yunzhi Li'; 'Jingoo Han'; 'Nick Hudson'
> Subject: [PATCH] MAINTAINERS: update maintainer entry for dwc2 driver
> 
> Update the MAINTAINERS entry for the dwc2 driver to show John Youn
> as the new maintainer
> 
> Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3589d67..8096bea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3028,7 +3028,7 @@ S:	Maintained
>  F:	drivers/platform/x86/dell-wmi.c
> 
>  DESIGNWARE USB2 DRD IP DRIVER
> -M:	Paul Zimmerman <paulz@synopsys.com>
> +M:	John Youn <johnyoun@synopsys.com>
>  L:	linux-usb@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>  S:	Maintained
> --
> 1.7.6.5

