Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3AXKHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:07:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52653 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab3AXKHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:07:03 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rob@landley.net" <rob@landley.net>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
 tree binding
Thread-Topic: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
 tree binding
Thread-Index: AQHN+YEX5mdJGMimIk6+yhi+9UfYCZhX8ngw///yR4CAAFxmAA==
Date: Thu, 24 Jan 2013 10:06:42 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB530BB@DBDE01.ent.ti.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
 <20130104122612.GM4627@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB50DCF@DBDE01.ent.ti.com>
 <20130123154804.GB4565@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB52FD9@DBDE01.ent.ti.com>
 <20130124100252.GE4955@opensource.wolfsonmicro.com>
In-Reply-To: <20130124100252.GE4955@opensource.wolfsonmicro.com>
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

On Thu, Jan 24, 2013 at 15:32:55, Mark Brown wrote:
> On Thu, Jan 24, 2013 at 09:33:34AM +0000, Hebbar, Gururaja wrote:
> 
> > So, by just using the SND_SOC_DAPM_POST_PMU & SND_SOC_DAPM_PRE_PMD I can mask 
> > & handle one particular voltage. 
> 
> What makes you say that?  That is just not true.

What I meant was that by using this macro (SND_SOC_DAPM_POST_PMU &
SND_SOC_DAPM_PRE_PMD) I can just save and restore existing voltage values inside
the event. They will not be user configurable (available to user through some widget).


> 


Regards, 
Gururaja
