Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3GASRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:17:11 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:14897 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab3GASRJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:17:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1372702578!11748315!27
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mark Brown <broonie@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Ryan Mallon <rmallon@gmail.com>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Mon, 1 Jul 2013 13:15:40 -0500
Subject: RE: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
Thread-Topic: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
Thread-Index: Ac52RaslgGyL/f1iRAe3W27XhwAydwAQQtMA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFB9@AUSP01VMBX24.collaborationhost.net>
References: <201306281143.35130.hartleys@visionengravers.com>
 <20130701102757.GF27646@sirena.org.uk>
In-Reply-To: <20130701102757.GF27646@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 01, 2013 3:28 AM, Mark Brown wrote:
> On Fri, Jun 28, 2013 at 11:43:34AM -0700, H Hartley Sweeten wrote:
>> __spi_async(), which starts every SPI message transfer, initializes
>> the bits_per_word and max speed for every transfer in the message.
>> Since the conditional test in ep93xx_spi_process_transfer() will
>> always succeed just remove it and always call ep93xx_spi_chip_setup()
>> to configure the hardware for each transfer in the message.
>
> Applied, thanks.

Mark,

I was going to redo this series based on the comments I have received
so far. Did you already apply this one? Should I push it to the front of my
patchset?

Regards,
Hartley

