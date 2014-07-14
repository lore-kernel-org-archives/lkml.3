Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaGNTds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:33:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43904 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaGNTdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:33:41 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Topic: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Index: AQHPnR8NkdNoCbyJA0aqgNzAA6CyVQ==
Date: Mon, 14 Jul 2014 19:33:35 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49D80BB3@DFLE09.ent.ti.com>
References: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
 <20140714184321.GW6800@sirena.org.uk>
 <00FC9A978A94B7418C33AFAE8A35ED49D80B10@DFLE09.ent.ti.com>
 <20140714191711.GI6800@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark

On 07/14/2014 02:17 PM, Mark Brown wrote:
> On Mon, Jul 14, 2014 at 07:07:06PM +0000, Murphy, Dan wrote:
>> On 07/14/2014 01:43 PM, Mark Brown wrote:
>>>> +config SND_SOC_TAS2552
>>>> +	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
>>>> +	depends on I2C
>>>> +
>>>>  endmenu
>>> Keep this and Makefile sorted - since this is a proper CODEC driver it
>>> should be in with the CODECs and also sorted in alphabetical order.
>> OK.  I was trying to stay away from a conflict by adding to the
>> bottom of the file.
> The whole point is to avoid conflicts - if everyone adds at the bottom
> of the file any two adds are pretty much guaranteed to conflict either
> on application or on merge.  Sorting avoids most of these and makes any
> that do occur much clearer.

No worries I will fix it

-- 
------------------
Dan Murphy

