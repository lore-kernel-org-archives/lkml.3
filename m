Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaAIDyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:54:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50277 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaAIDyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 22:54:10 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework
 queue
Thread-Topic: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework
 queue
Thread-Index: AQHPDDWnmSJXjKxnKk6thvl98nbtfJp6GWKAgAGquZA=
Date: Thu, 9 Jan 2014 03:53:15 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172F45B62@penmbx01>
References: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
 <52CD279B.6020203@gmail.com>
In-Reply-To: <52CD279B.6020203@gmail.com>
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

Hi Richard,

> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: Wednesday, January 08, 2014 6:26 PM
> To: Yang, Wenyou
> Cc: broonie@kernel.org; Ferre, Nicolas; linux-spi@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework
> queue
> 
> On 08/01/2014 06:49, Wenyou Yang wrote:
> > Replace the deprecated master->transfer with transfer_one_message()
> > and allow the SPI subsystem handle all the queuing of messages.
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> > Hi Mark,
> >
> > The patch is based on for-next branch of
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
> >
> > It is tested on sama5d3xek and at91sam9m10g45ek board.
> 
> And the bug I was seeing with SPI_IOC_MESSAGE (cf
> https://lkml.org/lkml/2013/10/8/269 ) is now gone !
> 
> Tested on at91sam9g35-ek
> 
> Tested-by: Richard Genoud <richard.genoud@gmail.com>
> 
Thanks a lot for your testing.

