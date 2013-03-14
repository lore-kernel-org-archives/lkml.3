Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3CNMzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:55:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60711 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684Ab3CNMzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:55:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH 2/3] pwm: pwm-tiecap: Add device-tree binding support
 for da850 SOC
Thread-Topic: [PATCH 2/3] pwm: pwm-tiecap: Add device-tree binding support
 for da850 SOC
Thread-Index: AQHOIJ9dx623btCsUEejQOTf1qQnkZiktL8AgABp72A=
Date: Thu, 14 Mar 2013 12:54:08 +0000
Deferred-Delivery: Thu, 14 Mar 2013 12:54:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA96FA1@DBDE01.ent.ti.com>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
 <1363257158-11615-3-git-send-email-avinashphilip@ti.com>
 <5141B7CC.7000700@ti.com>
In-Reply-To: <5141B7CC.7000700@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2ECta6O030294

On Thu, Mar 14, 2013 at 17:13:08, Nori, Sekhar wrote:
> On 3/14/2013 4:02 PM, Philip Avinash wrote:
> > ECAP IP is used in da850 SOC's also. Hence adds ECAP device tree binding
> > support for da850.
> > 
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Rob Landley <rob@landley.net>
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > :100644 100644 131e8c1... fcbd3c1... M	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > :100644 100644 22e96e2... e0d96c8... M	drivers/pwm/pwm-tiecap.c
> >  .../devicetree/bindings/pwm/pwm-tiecap.txt         |    2 +-
> >  drivers/pwm/pwm-tiecap.c                           |    1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > index 131e8c1..fcbd3c1 100644
> > --- a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > @@ -1,7 +1,7 @@
> >  TI SOC ECAP based APWM controller
> >  
> >  Required properties:
> > -- compatible: Must be "ti,am33xx-ecap"
> > +- compatible: Must be "ti,am33xx-ecap" or "ti,da850-ecap"
> >  - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
> >    First cell specifies the per-chip index of the PWM to use, the second
> >    cell is the period in nanoseconds and bit 0 in the third cell is used to
> > diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
> > index 22e96e2..e0d96c8 100644
> > --- a/drivers/pwm/pwm-tiecap.c
> > +++ b/drivers/pwm/pwm-tiecap.c
> > @@ -197,6 +197,7 @@ static const struct pwm_ops ecap_pwm_ops = {
> >  
> >  static const struct of_device_id ecap_of_match[] = {
> >  	{ .compatible	= "ti,am33xx-ecap" },
> > +	{ .compatible	= "ti,da850-ecap" },
> >  	{},
> 
> You add a new compatible, but don't really show any changes in driver in
> this series. So why can't we simply use ti,am33xx-ecap on DA850 too?

Ok it can happily live with ti,am33xx-ecap. Hence this patch and next [1]patch
can be dropped.

1. [PATCH 3/3] pwm: pwm-tiehrpwm: Add device tree binding support for da850 SOC

Thanks
Avinash
> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
