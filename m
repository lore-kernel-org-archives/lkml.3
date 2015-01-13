Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbAMQDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:03:34 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37315 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751997AbbAMQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:03:31 -0500
Date: Tue, 13 Jan 2015 16:03:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150113160313.GR12302@n2100.arm.linux.org.uk>
References: <20150109200127.GD12302@n2100.arm.linux.org.uk>
 <1421054728.3081.28.camel@pengutronix.de>
 <20150112122527.GF12302@n2100.arm.linux.org.uk>
 <1421071197.3081.44.camel@pengutronix.de>
 <20150112140456.GI12302@n2100.arm.linux.org.uk>
 <20150112181341.4a53ea24@armhf>
 <20150112175705.GN12302@n2100.arm.linux.org.uk>
 <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113165411.5469930d@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:54:11PM +0100, Jean-Francois Moine wrote:
> 4 streams on 4 different APs (sources) should work, but 4 streams from
> a same source should be detailed.

I'd like to know how you intend to wire up four different I2S sources
to the TDA998x.

Remember, an I2S source produces the I2S data and the word clock - that's
two outputs.  You can't electronically wire the word clocks together.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
