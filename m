Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaJWS2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:28:10 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:56178 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJWS2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:28:08 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Thread-Topic: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Thread-Index: AQHP7JesnDFIW03SEUaNZEZCzxwRS5w8gsUAgAGAllA=
Date: Thu, 23 Oct 2014 18:28:03 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E54AC@US01WEMBX2.internal.synopsys.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
 <9429092.fliZzSsbVp@amdc1032>
In-Reply-To: <9429092.fliZzSsbVp@amdc1032>
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

> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Wednesday, October 22, 2014 5:26 AM
> 
> On Monday, October 20, 2014 01:52:06 PM dinguyen@opensource.altera.com wrote:
> > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >
> >  config USB_DWC2_PLATFORM
> >  	bool "DWC2 Platform"
> > -	depends on USB_DWC2_HOST
> >  	default USB_DWC2_HOST
> 
> It should be "default USB_DWC2_HOST || USB_DWC2_PERIPHERAL" because
> USB_DWC2_PLATFORM replaces current USB_DWC2_PERIPHERAL functionality.
> 
> Additionaly USB_DWC2_PLATFORM should be changed to tristate
> (USB_DWC2_PERIPHERAL was a tristeate before your changes).

Dinh, I think this is a good point. Is there any reason why
USB_DWC2_PLATFORM (and USB_DWC2_PCI for that matter) can't be
tristate? That's what DWC3 does.

-- 
Paul

