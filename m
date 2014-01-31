Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaAaGZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 01:25:15 -0500
Received: from mail.sensor-technik.de ([80.150.181.156]:51288 "EHLO
	mail.sensor-technik.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaAaGZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 01:25:10 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 01:25:09 EST
X-IronPort-AV: E=Sophos;i="4.95,755,1384297200"; 
   d="scan'208";a="546242"
From: Waibel Georg <Georg.Waibel@sensor-technik.de>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
CC: Gerhard Sittig <gsi@denx.de>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH 1/1] iMX gpio: Allow reading back of pin status if
 configured as gpio output
Thread-Topic: [PATCH 1/1] iMX gpio: Allow reading back of pin status if
 configured as gpio output
Thread-Index: Ac8Tjf3aVV6M/uKQT66xiOgnnC2hVQACO1mAAA5hlrwBDVHuAAGRIh0g
Date: Fri, 31 Jan 2014 06:14:59 +0000
Message-ID: <E1C9442006A9AE48A7A4B85E0D01C4D4750C36@stwexdb.stww2k.local>
References: <E1C9442006A9AE48A7A4B85E0D01C4D474F059@stwexdb.stww2k.local>
	<20140117161513.GC20094@book.gsilab.sittig.org>
	<E1C9442006A9AE48A7A4B85E0D01C4D474F13C@stwexdb.stww2k.local>
 <CACRpkdZsd7rwRrYKVZEP7VOG56k80fbetORqF9Zu+Tz_q15f2A@mail.gmail.com>
In-Reply-To: <CACRpkdZsd7rwRrYKVZEP7VOG56k80fbetORqF9Zu+Tz_q15f2A@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.64.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TBoneOriginalFrom: Waibel Georg <Georg.Waibel@sensor-technik.de>
X-TBoneOriginalTo: 'Linus Walleij' <linus.walleij@linaro.org>
X-TBoneOriginalCC: Gerhard Sittig <gsi@denx.de>, Alexandre Courbot <gnurou@gmail.com>,
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-TBoneDomainSigned: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:40 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> I'm holding this off until you've made up your mind about whether it's needed or not...

By setting the SION bit the actual status of a gpio pin can be read back regardless of its driver configuration. 
You can drop my patch as there is no need for it.

Regards
Georg

