Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaKKAym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:54:42 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:39410 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKKAyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:54:41 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
CC: "khilman@kernel.org" <khilman@kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4] i2c/at91: adopt pinctrl support
Thread-Topic: [PATCH v4] i2c/at91: adopt pinctrl support
Thread-Index: AQHP/InvhgNJHH4o3UKhfhmASErLeZxZL4QAgAFo5TA=
Date: Tue, 11 Nov 2014 00:53:58 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFC71DAA@penmbx01>
References: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
 <54609DD8.8030903@cogentembedded.com>
In-Reply-To: <54609DD8.8030903@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: Monday, November 10, 2014 7:13 PM
> To: Yang, Wenyou; wsa@the-dreams.de; Desroches, Ludovic
> Cc: khilman@kernel.org; Ferre, Nicolas; linux-kernel@vger.kernel.org; linux-
> i2c@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v4] i2c/at91: adopt pinctrl support
> 
> Hello.
> 
> On 11/10/2014 4:55 AM, Wenyou Yang wrote:
> 
> > Amend the at91 i2c pin controller
> 
>     You're amending the hardware itself, really? :-)
> 
> > to optionally take a pin controlhandle
> 
>     I don't see the code that does this.
> 
> > and set the state of the pins to:
> > - "default" on boot and resume.
> 
>     I don't see where you are changing anything for the probe() method.
> Perhaps you meant the driver core code which selects the dafault profile
> automatically?
Yes, the driver core code default do, so remove the redundant code from _probe function.

> 
> > - "sleep" on suspend().
> 
> > This should make it possible to optimize energy usage for the pins
> > both for the suspend/resume cycle
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> > Hi Wolfram,
> >
> > Thanks a lot.
> >
> > The change of this version is to remove
> > 	pinctrl_pm_select_default_state(&pdev->dev) from the _probe function.
> 
>     Aha, you've specifically removed this...
> 
> WBR, Sergei

Best Regards,
Wenyou Yang

