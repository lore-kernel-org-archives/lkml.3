Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbbATQrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:47:03 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.119]:22058 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970AbbATQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:09 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 11:42:08 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-193.messagelabs.com!1421771728!23374845!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: RE: [PATCH V3 2/2] devicetree: Add bindings for DA9063
Thread-Topic: [PATCH V3 2/2] devicetree: Add bindings for DA9063
Thread-Index: AQHQNLl14LxvOA77vEqNWosHE6/EUJzJKSkAgAAJtmA=
Date: Tue, 20 Jan 2015 16:35:27 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B52E11@SW-EX-MBX02.diasemi.com>
References: <cover.1421762065.git.stwiss.opensource@diasemi.com>
 <99c7b7fb380070e5a2f7f4e9f333e8a2b12b591a.1421762065.git.stwiss.opensource@diasemi.com>
 <20150120155400.GI13701@x1>
In-Reply-To: <20150120155400.GI13701@x1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KGlB42013876

On 20 January 2015 15:54 Lee Jones wrote:

[...]

> >  Documentation/devicetree/bindings/mfd/da9063.txt | 93
> ++++++++++++++++++++++++
> >  1 file changed, 93 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt
> 
> I already Acked this?  Any reason that wasn't carried forward to this
> submission?  Has anything changed?
> 

Yes, I had to alter this bindings document because of the compatible change ...
See below:

> > new file mode 100644
> > index 0000000..42c6fa6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/da9063.txt
> > @@ -0,0 +1,93 @@
> > +* Dialog DA9063 Power Management Integrated Circuit (PMIC)
> > +
> > +DA9093 consists of a large and varied group of sub-devices (I2C Only):
> > +
> > +Device                   Supply Names    Description
> > +------                   ------------    -----------
> > +da9063-regulator        :               : LDOs & BUCKs
> > +da9063-rtc              :               : Real-Time Clock
> > +da9063-watchdog         :               : Watchdog
> > +
> > +======
> > +
> > +Required properties:
> > +
> > +- compatible : Should be "dlg,da9063"

The line above used to say "dlg,da9063-ad", "dlg,da9063-bb", etc.
Now it just says "dlg,da9063"

[...]

> > +
> > +Example:
> > +
> > +	pmic0: da9063@58 {
> > +		compatible = "dlg,da9063"

And I also change a  line in the example for the same reason.
Sorry for the confusion.

Regards,
Steve

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
