Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaJHHDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:03:39 -0400
Received: from mail-bn1bbn0107.outbound.protection.outlook.com ([157.56.111.107]:58368
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbaJHHDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:03:37 -0400
From: Muthu Mani <muth@cypress.com>
To: Johan Hovold <johan@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Topic: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Index: AQHP4WRWtG+8Ymra5kGuePekCkrwDpwjEVEAgAK3t4A=
Date: Wed, 8 Oct 2014 07:03:32 +0000
Message-ID: <44890a00b3914a5bb489cc95e5fe7cbf@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1412599949-3818-1-git-send-email-muth@cypress.com>
 <20141006133302.GA2306@localhost>
In-Reply-To: <20141006133302.GA2306@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR06MB459;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(164054003)(199003)(51704005)(377454003)(189002)(13464003)(120916001)(50986999)(21056001)(87936001)(19580395003)(19580405001)(95666004)(76176999)(31966008)(101416001)(99396003)(15202345003)(122556002)(20776003)(80022003)(33646002)(105586002)(85852003)(64706001)(85306004)(40100002)(54356999)(74316001)(106356001)(106116001)(86362001)(108616004)(77096002)(4396001)(76482002)(15975445006)(2656002)(46102003)(66066001)(110136001)(97736003)(107046002)(92566001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR06MB459;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Johan Hovold [mailto:jhovold@gmail.com] On Behalf Of Johan Hovold
> Sent: Monday, October 06, 2014 7:03 PM
> To: Muthu Mani
> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; linux-i2c@vger.kernel.org; Linus
> Walleij; Alexandre Courbot; linux-gpio@vger.kernel.org;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Rajaram Regupathy
> Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB
> Serial Bridge controller
> 
> On Mon, Oct 06, 2014 at 06:22:29PM +0530, Muthu Mani wrote:
> > Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> > CYUSBS234 USB-Serial Bridge controller.
> >
> > Details about the device can be found at:
> > http://www.cypress.com/?rID=84126
> >
> > Signed-off-by: Muthu Mani <muth@cypress.com>
> > Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> > ---
> 
> Please resend this series and include a revision changelog per patch (you can
> keep it under the cut-off line).
> 
> Also, make sure not to drop thread participants from CC when resending.

Thanks, I have resent it.

> 
> Thanks,
> Johan
