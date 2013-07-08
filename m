Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3GHQLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:11:22 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.196]:31211 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab3GHQLU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:11:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1373299872!12352020!18
X-Originating-IP: [216.166.12.7]
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
Date: Mon, 8 Jul 2013 11:10:10 -0500
Subject: RE: [PATCH v2 09/11] spi: spi-ep93xx: move the clock divider calcs
 into ep93xx_spi_chip_setup()
Thread-Topic: [PATCH v2 09/11] spi: spi-ep93xx: move the clock divider calcs
 into ep93xx_spi_chip_setup()
Thread-Index: Ac571CXbpz5tbhZ9QXGBl+vHLKkufgAIObLw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC390575@AUSP01VMBX24.collaborationhost.net>
References: <201307021010.30326.hartleys@visionengravers.com>
 <20130708121002.GZ27646@sirena.org.uk>
In-Reply-To: <20130708121002.GZ27646@sirena.org.uk>
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

On Monday, July 08, 2013 5:10 AM, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 10:10:29AM -0700, H Hartley Sweeten wrote:
>> The divider values stored in the per chip data are only used to set the
>> registers in the hardware to generate the desired SPI clock. Since these
>> are calculated per transfer based on the t->speed_hz there is no reason
>> keep them in the per chip data.
>
> Applied, thanks.  I don't seem to have been sent patch 10?

Thanks.

Looks like I fat-fingered the To: address on patches 10 and 11 of the series.

I'll repost them in just a sec.

Regards,
Hartley
