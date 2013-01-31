Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3AaL11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:27:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42734 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3AaL10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:27:26 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH v3 1/4] ASoC: tlv320aic3x: Convert mic bias to a supply
 widget
Thread-Topic: [PATCH v3 1/4] ASoC: tlv320aic3x: Convert mic bias to a supply
 widget
Thread-Index: AQHN/6U5pGhRJT3kcEGcYmC+XsWA1phi74MAgABcfwA=
Date: Thu, 31 Jan 2013 11:27:07 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB5A48E@DBDE01.ent.ti.com>
References: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
 <1359631394-9511-2-git-send-email-gururaja.hebbar@ti.com>
 <20130131112414.GE11078@opensource.wolfsonmicro.com>
In-Reply-To: <20130131112414.GE11078@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 16:54:16, Mark Brown wrote:
> On Thu, Jan 31, 2013 at 04:53:10PM +0530, Hebbar Gururaja wrote:
> 
> > :100644 100644 e7b98f4... f47c3f5... M	Documentation/devicetree/bindings/sound/tlv320aic3x.txt
> > :100644 100644 ffd9bc7... 9407fd0... M	include/sound/tlv320aic3x.h
> > :100644 100644 4989143... 65d09d6... M	sound/soc/codecs/tlv320aic3x.c
> > :100644 100644 6db3c41... e521ac3... M	sound/soc/codecs/tlv320aic3x.h
> 
> As mentioned when you posted this before this patch needs to update the
> machine drivers using the device too.

The patch-set 2/4 does the same thing. Since I have da850-evm at my end, I 
have modified that machine driver and sent-it as 2/4.

> 


Regards, 
Gururaja
