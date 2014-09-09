Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaIINtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:49:32 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:51146 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaIINta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:49:30 -0400
From: "Vaittinen, Matti (NSN - FI/Oulu)" <matti.vaittinen@nsn.com>
To: ext Jason Cooper <jason@lakedaemon.net>, Pavel Machek <pavel@denx.de>
CC: ext Mark Rutland <mark.rutland@arm.com>,
        ext Guenter Roeck <linux@roeck-us.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "Sverdlin, Alexander (NSN - DE/Ulm)" <alexander.sverdlin@nsn.com>
Subject: VS: [PATCH] rtc: ds1307: add trickle charger device tree binding
Thread-Topic: [PATCH] rtc: ds1307: add trickle charger device tree binding
Thread-Index: Ac/CtIam5hxTdbCPTFyeXWxdTlu5bv//9SmAgAAwQICAAAUpgIAACp6AgAALQQCAAANRAIABCoAAgAASVgCAD+0lAIAAElyAgAEjmgCAADW8gIAAAiKAgABB2W0=
Date: Tue, 9 Sep 2014 13:48:36 +0000
Message-ID: <3AEAD721A6ADC64CB2CA46CCC17551A0B8492B@DEMUMBX013.nsn-intra.net>
References: <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej> <20140908135242.GA21412@amd>
 <20140908145825.GO12081@leverpostej>
 <20140909062158.GB21342@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140909113425.GC15404@amd>,<20140909114203.GL30828@titan.lakedaemon.net>
In-Reply-To: <20140909114203.GL30828@titan.lakedaemon.net>
Accept-Language: fi-FI, en-US
Content-Language: fi-FI
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [93.183.12.64]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 486
X-purgate-ID: 151667::1410270520-00002A30-B9A4B722/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lähettäjä: ext Jason Cooper 

> meh.  The presence or absence of the property should express the
boolean.
> 
> The safe state should be the default (property absent), and the property
name should describe the state when the property is present.

This is What the v5 of patch does. It introduces boolean flag trickle-diode-disable. Diode enabled should be safer and it is also the default.
Jason, I added your ack to that patch, thanks.

Br. Matti Vaittinen 