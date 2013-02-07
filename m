Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3BGJGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:06:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56655 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3BGJGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:06:05 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 00/10] video: da8xx-fb: runtime timing configuration
Thread-Topic: [PATCH v3 00/10] video: da8xx-fb: runtime timing configuration
Thread-Index: AQHN8yRtEJqz8/nDxkaDr6ir7XxsA5huO+lQ
Date: Thu, 7 Feb 2013 09:05:59 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA2846@DBDE01.ent.ti.com>
References: <cover.1358250489.git.afzal@ti.com>
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1796E7I027855

Hi Tomi, Florian,

On Tue, Jan 15, 2013 at 19:00:50, Mohammed, Afzal wrote:

> This series makes da8xx-fb driver (device found on DaVinci and AM335x)
> capable of handling runtime timing configuration by adding fb_set_par.
> 
> The last change adds actual fb_set_par support. Other preceeding
> changes makes the way clear for it as well as does certain cleanup's
> on the way.
> 
> This has been tested on da850 evm as is. This was also tested on
> am335x-evm & am335x-evmsk with a series that adds DT support.
> 
> This is based on v3.8-rc3, this is the only change in this revision.
> The new version of this series is being posted so that this series can
> be applied easily (as __dev* are removed, there would be merge
> conflicts with v2, which was based on -rc2).
> series

Can you please consider this series for inclusion. There are no
pending comments or dependency for this series. If you need a
pull request, let me know, I will sent it.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
