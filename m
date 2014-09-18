Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaIRNel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:34:41 -0400
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:49696
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755267AbaIRNek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:34:40 -0400
Date: Thu, 18 Sep 2014 21:34:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <stefan@agner.ch>, <jic23@kernel.org>, <B38611@freescale.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Implement temperature sensor for vf610-adc
Message-ID: <20140918133426.GI4796@dragon>
References: <cover.1411039381.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1411039381.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(21056001)(19580405001)(84676001)(86362001)(4396001)(85306004)(87936001)(46406003)(104016003)(64706001)(50986999)(68736004)(33716001)(19580395003)(97756001)(106466001)(83506001)(76176999)(97736003)(83072002)(69596002)(92726001)(79102003)(74662003)(77982003)(107046002)(110136001)(57986006)(20776003)(46102003)(23726002)(50466002)(44976005)(102836001)(92566001)(6806004)(47776003)(85852003)(105606002)(81542003)(74502003)(54356999)(1411001)(83322001)(31966008)(99396002)(76482002)(81342003)(81156004)(33656002)(95666004)(90102001)(26826002)(80022003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB369;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 05:23:22PM +0530, Sanchayan Maity wrote:
> Vybrid ADC peripheral includes a temperature sensor
> which is connected to channel number 26. The patch
> adds support for the sensor. The raw value is read
> and the temperature calculated in milli degree Celsius,
> which is returned using IIO_CHAN_INFO_PROCESSED option.
> 
> Sanchayan Maity (1):
>   ARM: imx: vf610-adc: Add temperature sensor support

This is not an arch/arm/mach-imx patch, so shouldn't be prefixed with
"ARM: imx: ".  And also it's more appropriate to put Jonathan Cameron
<jic23@kernel.org> on "To:", since he is responsible for picking
drivers/iio/adc patches.

Shawn

> 
>  drivers/iio/adc/vf610_adc.c |   28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> -- 
> 1.7.9.5
> 
