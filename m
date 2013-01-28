Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3A1JRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:17:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57877 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3A1JRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:17:38 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "paul@pwsan.com" <paul@pwsan.com>, "Nayak, Rajendra" <rnayak@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>
Subject: RE: RE: RE: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider
 handling
Thread-Topic: RE: RE: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider
 handling
Thread-Index: AQHN+V/MaSDyqI8pmkmZ9mAn8r3xs5hW/6oAgAFRCtCAAAkKAIABj9VwgABiqICABBidkA==
Date: Mon, 28 Jan 2013 09:17:19 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA943E9@DBDE01.ent.ti.com>
References: <cover.1358937685.git.afzal@ti.com>
 <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
 <20130123202204.9205.66575@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ADF@DBDE01.ent.ti.com>
 <20130124170044.10623.45314@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA9383E@DBDE01.ent.ti.com>
 <20130125224453.10623.74434@quantum>
In-Reply-To: <20130125224453.10623.74434@quantum>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0S9Hhdd000403

Hi Mike,

On Sat, Jan 26, 2013 at 04:14:53, Mike Turquette wrote:

> I think Paul W. or someone on the TI side should weigh in on your clkdev
> entries.  My main point is that the actual tree should be modeled and
> clocks shouldn't be globbed together unnecessarily.  As mentioned in the
> other mail thread you might be better off making a divider for your LCDC
> IP block and modeling each node individually.

It seems complexity of driver would increase by creating a new inherited
divider clock and having a total 3-4 clock nodes. The advantage going
with it would be higher configurable resolution for pixel clock.
Current use cases work without higher pixel clock resolution.

And drm driver posted for the same IP is without CCF modeling.

So I will presently not model clock nodes in LCDC IP, later if use cases
badly require, this can be done (and if it happens, hopefully by that
DaVinci would be CCF'ed and it would be more clean to implement it).

Thanks for sharing your ideas.

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
