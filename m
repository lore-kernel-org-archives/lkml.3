Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3GBLvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:51:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46034 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3GBLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:51:00 -0400
Message-ID: <51D2BEA1.6010206@free-electrons.com>
Date: Tue, 02 Jul 2013 13:50:57 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        brian@crystalfontz.com, linux-doc@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jimwall@q.com, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com> <CAOMZO5CLcT=OXYd=ggxpDzUqFxoXSaanqUPGugYLT2Og-VgzCA@mail.gmail.com> <51D2BB05.9040201@free-electrons.com> <CAOMZO5DZufiOjguOCEbe5n0j=w9B5ezBYh0Rejv3zF5Xht5_qQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DZufiOjguOCEbe5n0j=w9B5ezBYh0Rejv3zF5Xht5_qQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 13:45, Fabio Estevam wrote:

> Shouldn't this be
> 
>          i2c@1 {
>                  reg = <1>; ?
> 

No, we have 4 devices on that mux and 2 pins to select the muxing.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
