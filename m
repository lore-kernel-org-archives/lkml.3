Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3GASaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:30:05 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:21469 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab3GASaE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:30:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1372703401!19820857!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Mika Westerberg <mika.westerberg@iki.fi>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>
Date: Mon, 1 Jul 2013 13:28:58 -0500
Subject: RE: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Thread-Topic: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Thread-Index: Ac51rPZNmmxg83eoSOydU4YpXPK+zwA2tlLQAAA2LmA=
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFC3@AUSP01VMBX24.collaborationhost.net>
References: <201306281143.07615.hartleys@visionengravers.com>
	<20130630161358.GA786@mwesterb-mobl.lan>
 <ADE657CA350FB648AAC2C43247A983F0021DAC38FFBD@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFBD@AUSP01VMBX24.collaborationhost.net>
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

On Monday, July 01, 2013 11:23 AM, H Hartley Sweeten wrote:
> On Sunday, June 30, 2013 9:14 AM, Mika Westerberg wrote:
>> Please use SPI_BPW_RANGE_MASK(4, 16) here.
>
> I thought there was a macro for this, just couldn't find it. I'll fix this.

Doh... This patch is already in linux-next.

I'll need to rebase this series.

Regards,
Hartley
