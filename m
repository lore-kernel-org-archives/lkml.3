Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3AWM1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:27:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3AWM1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:27:45 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Rob Clark <robdclark@gmail.com>, Koen Kooi <koen@dominion.thruhere.net>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: RE: [PATCH v3 00/12] video: da8xx-fb: am335x DT support
Thread-Topic: [PATCH v3 00/12] video: da8xx-fb: am335x DT support
Thread-Index: AQHN+MDYoJpa4cfnpkmrt/FePfrjS5hVNzoAgAAcRYCAAYJFUA==
Date: Wed, 23 Jan 2013 12:27:21 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA911BF@DBDE01.ent.ti.com>
References: <cover.1358871750.git.afzal@ti.com>
	<02F0A27B-B16B-42F8-A0BC-29726732226D@dominion.thruhere.net>
 <CAF6AEGuyb26EZ_9=GP9gs0TZqUtiFv3D_7+wcDOHuKn2qUcytQ@mail.gmail.com>
In-Reply-To: <CAF6AEGuyb26EZ_9=GP9gs0TZqUtiFv3D_7+wcDOHuKn2qUcytQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0NCRpAR003670

Hi,

On Wed, Jan 23, 2013 at 00:15:09, Rob Clark wrote:

> > Wouldn't it be better to delete da8xx-fb.* and switch to Rob Clarks DRM based driver for this IP block?

> we probably can't delete da8xx-fb, but I think it would be ok to only
> use it for legacy platforms not yet ported to DT.

We can't remove da8xx-fb as DA830 is a non-DT one and DA850 is only gaining
DT support.

And Rob,

I am not familiar with drm setup, would all the user space frame buffer based
applications work as is with drm driver?

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
