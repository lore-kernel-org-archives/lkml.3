Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3AaLty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:49:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33568 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3AaLtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:49:51 -0500
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
Thread-Index: AQHN/6U5pGhRJT3kcEGcYmC+XsWA1phi74MAgABcfwD//6VJAIAAYS6g
Date: Thu, 31 Jan 2013 11:49:29 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB5A52E@DBDE01.ent.ti.com>
References: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
 <1359631394-9511-2-git-send-email-gururaja.hebbar@ti.com>
 <20130131112414.GE11078@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB5A48E@DBDE01.ent.ti.com>
 <20130131113035.GF11078@opensource.wolfsonmicro.com>
In-Reply-To: <20130131113035.GF11078@opensource.wolfsonmicro.com>
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

On Thu, Jan 31, 2013 at 17:00:38, Mark Brown wrote:
> On Thu, Jan 31, 2013 at 11:27:07AM +0000, Hebbar, Gururaja wrote:
> > On Thu, Jan 31, 2013 at 16:54:16, Mark Brown wrote:
> 
> > > As mentioned when you posted this before this patch needs to update the
> > > machine drivers using the device too.
> 
> > The patch-set 2/4 does the same thing. Since I have da850-evm at my end, I 
> > have modified that machine driver and sent-it as 2/4.
> 
> Two problems here.  One is that the update should be done in the same
> patch and the other is that you need to update *all* the machine drivers
> using the device, not just one of them.

Ok, I will send the updated version now.

> 


Regards, 
Gururaja
