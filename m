Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127Ab3GCTBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:01:06 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:9818 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964816Ab3GCTBE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:01:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1372878042!11974484!24
X-Originating-IP: [216.166.12.32]
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
Date: Wed, 3 Jul 2013 14:00:22 -0500
Subject: RE: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Thread-Topic: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Thread-Index: Ac54GidSSraY9Zz7QqaacZr9NK6VCAABTzdA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC390360@AUSP01VMBX24.collaborationhost.net>
References: <201307021008.22347.hartleys@visionengravers.com>
 <20130703182125.GZ27646@sirena.org.uk>
In-Reply-To: <20130703182125.GZ27646@sirena.org.uk>
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

On Wednesday, July 03, 2013 11:21 AM, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 10:08:21AM -0700, H Hartley Sweeten wrote:
>> Use devm_clk_get() so that the clk_put() happens automatically when
>> the last reference to this driver is dropped.
>
> This doesn't apply against current code - always submit against the
> relevant development tree, in this case topic/ep93xx.  I've applied it
> with a manual fixup.

Sorry about the trouble. Thanks for fixing it.

Regards,
Hartley

