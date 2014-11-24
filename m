Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKXIqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:46:09 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:13366 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbaKXIqH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:46:07 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-194.messagelabs.com!1416818756!21781495!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
CC: Support Opensource <Support.Opensource@diasemi.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: RE: [PATCH v2 2/2] regulator: da9063: Do not transform local IRQ to
 virtual
Thread-Topic: [PATCH v2 2/2] regulator: da9063: Do not transform local IRQ
 to virtual
Thread-Index: AQHQBZ/xfEH3KKlXlk+aqcYvlUyTB5xrYq4AgAQXXcA=
Date: Mon, 24 Nov 2014 08:45:55 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B4A26E@SW-EX-MBX02.diasemi.com>
References: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1416583748-6622-3-git-send-email-d.lavnikevich@sam-solutions.com>
 <20141121181418.GZ3815@sirena.org.uk>
In-Reply-To: <20141121181418.GZ3815@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 21 November 2014 18:14 Mark Brown wrote

> To: Dmitry Lavnikevich
> Subject: Re: [PATCH v2 2/2] regulator: da9063: Do not transform local IRQ to virtual
> 
> On Fri, Nov 21, 2014 at 06:29:08PM +0300, Dmitry Lavnikevich wrote:
> > Call platform_get_irq_byname() already returns VIRQ instead of local
> > IRQ. Passing this value to regmap_irq_get_virq() causes error which
> > results in IRQ registration failure. This patch fixes such behaviour.
> 
> Applied, thanks.

Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
