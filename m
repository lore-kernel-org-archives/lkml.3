Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3HZTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:53:36 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:38326 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3HZTxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:53:34 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "Benson Leung" <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Subject: RE: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Thread-Topic: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support
 for platform xHCs
Thread-Index: AQHOnfwYI9Np33Plqkq7vUNbfD4u75mgdUEAgAAzMICAADKpAIAAPKeA//+VVhCAB60tgP//i2hQgAAJMfA=
Date: Mon, 26 Aug 2013 19:53:33 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DED841@US01WEMBX2.internal.synopsys.com>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
 <20130826191411.GG5112@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
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

> From: Paul Zimmerman
> Sent: Monday, August 26, 2013 12:38 PM

...

> So it may be safer to say that the feature is present starting with 2.50a.
> 
> In 2.51a it has been well-tested in simulation. In actual hardware, it

That should have said:

"In 2.50a it has been well-tested in simulation..."

-- 
Paul

