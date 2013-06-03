Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3FCHuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:50:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57784 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab3FCHuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:50:11 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Jon Hunter <jgchunter@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
Thread-Topic: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
Thread-Index: AQHOWufOwwwB7s/tqE2Htmmr900F0pkal7yAgAALLwCAAST2AP//jDYAgACKqgD//8gegIAH+0+Q
Date: Mon, 3 Jun 2013 07:49:28 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EB1238B@DBDE04.ent.ti.com>
References: <cover.1369658705.git.afzal@ti.com>
 <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com>
 <51A520B5.8040803@gmail.com> <51A52A16.1040204@wwwdotorg.org>
 <C8443D0743D26F4388EA172BF4E2A7A93EAFB044@DBDE04.ent.ti.com>
 <51A5BEB6.6070809@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EAFB174@DBDE04.ent.ti.com>
 <51A60427.6010409@ti.com>
In-Reply-To: <51A60427.6010409@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r537oNmM005251

Hi Benoit,

On Wed, May 29, 2013 at 19:05:35, Cousson, Benoit wrote:

> And in this case, you do not introduce any new revision.
> 
> There is no point to update the binding each time we add a new SoC
> variant that will contain the exact same IP.
> 
> I think it will mainly confuse the user that will wonder what is
> different in that version compare to the previous one, moreover we can
> end up with hundred of entries for the exact same IP for nothing.
> 
> The real problem is due to the introduction of the SoC name in the
> device compatible name. That does introduced a SoC level information
> that is mostly irrelevant at device level. I can understand why it was
> done for practical aspect when the IP version is not well identified,
> but that can lead to this proliferation of new pointless bindings.

As opinions on $subject seems not yet to be conclusive, I plan to
rebase DTS patch (14/14) over your 'for_3.11/dts' branch (that makes
use of C preprocessor on OMAP DTS) and post separately dropping
11-14 patches, is that okay ?

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
