Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaLHQA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:00:26 -0500
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:3024
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbaLHQAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:00:23 -0500
From: Muthu Mani <muth@cypress.com>
To: Johan Hovold <johan@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Topic: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Index: AQHQC5xRLcajWp5gcU6XRxdPQz74M5yF4mWAgAAC7UA=
Date: Mon, 8 Dec 2014 16:00:13 +0000
Message-ID: <BN1PR06MB069088C07483AEA527DD338CC640@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1417241944-17799-1-git-send-email-muth@cypress.com>
 <20141208153701.GD14346@localhost>
In-Reply-To: <20141208153701.GD14346@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR0601MB724;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR0601MB724;
x-forefront-prvs: 041963B986
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(164054003)(43544003)(24454002)(51164003)(199003)(51704005)(20776003)(54606007)(99396003)(66066001)(33656002)(101416001)(31966008)(54206007)(19580405001)(19580395003)(86362001)(76176999)(87936001)(54356999)(62966003)(77156002)(120916001)(50986999)(92566001)(2656002)(110136001)(105586002)(106116001)(106356001)(99286002)(107046002)(122556002)(40100003)(68736005)(97736003)(21056001)(74316001)(46102003)(76576001)(102836002)(4396001)(15975445007);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR0601MB724;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Nov 29, 2014 at 11:49:04AM +0530, Muthu Mani wrote:
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
> This patch as well as the other two patches in the series is white-space
> damaged. Please always make sure to run your patches through
> checkpatch.pl before submission (and/or fix your mailer).
>
> Also use git-send-email when submitting your series so that the individual
> patches get threaded properly.

Sorry about the inconvenience.
I ran checkpatch.pl for all the patches before I submitted them using git-send-email.
checkpatch doesn't show any error.

I used the following command to submit patch. Please let me know if anything wrong.
$ git format-patch -s -n -v4 master..Driver_v4
$ git send-email --smtp-encryption=tls --smtp-server=<mail-server> --smtp-user=muth@cypress.com --smtp-server-port=<port#> --to="Samuel Ortiz <sameo@linux.intel.com>" --to="Lee Jones <lee.jones@linaro.org>" --to="Wolfram Sang <wsa@the-dreams.de>" --to="Linus Walleij <linus.walleij@linaro.org>" --to="Alexandre Courbot <gnurou@gmail.com>" --to="gregkh@linuxfoundation.org"  --to="Johan Hovold <johan@kernel.org>" --cc="linux-usb@vger.kernel.org"  --cc="linux-kernel@vger.kernel.org" --cc="linux-i2c@vger.kernel.org" --cc="linux-gpio@vger.kernel.org" v4-0001-mfd-add-support-for-Cypress-CYUSBS234-USB-Serial-.patch

>
> And always increase (or add a "resend" prefix) when resending. I got two
> v4 series in my inbox. No idea what's the difference, if any.

In the second v4 patch, I added Greg KH and usb group. There is no code changes.
I will take care when I resend again.

Thanks,
Muthu

>
> Thanks,
> Johan

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
