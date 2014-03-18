Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaCRJdu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 18 Mar 2014 05:33:50 -0400
Received: from f500.i.mail.ru ([185.5.137.9]:41918 "EHLO f500.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaCRJdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:33:49 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 05:33:49 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        cooloney@gmail.com
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWZkOiBtYzEzeHh4OiBNb3ZlIGRlZmluaXRpb25zIG91?=
 =?UTF-8?B?dCBvZiBzdHJ1Y3R1cmVz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 18 Mar 2014 13:33:46 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1395135226.132641029@f500.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140318092735.GK25478@lee--X1>
References: <1394867287-14074-1-git-send-email-shc_work@mail.ru>
 <1395134091.369687348@f500.i.mail.ru>
 <20140318092735.GK25478@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s2I9Y0U5023883

Tue, 18 Mar 2014 09:27:35 +0000 Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> > > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > > > ---
> > > >  include/linux/mfd/mc13xxx.h | 22 ++++++++++++----------
> > > >  1 file changed, 12 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
> > > > index a326c85..d63b1d3 100644
> > > > --- a/include/linux/mfd/mc13xxx.h
> > > > +++ b/include/linux/mfd/mc13xxx.h
> > > > @@ -117,10 +117,6 @@ struct mc13xxx_led_platform_data {
> > > >  
> > > >  #define MAX_LED_CONTROL_REGS	6
> > > >  
> > > > -struct mc13xxx_leds_platform_data {
> > > > -	struct mc13xxx_led_platform_data *led;
> > > > -	int num_leds;
> > > > -
> > > >  /* MC13783 LED Control 0 */
> > > >  #define MC13783_LED_C0_ENABLE		(1 << 0)
> > > >  #define MC13783_LED_C0_TRIODE_MD	(1 << 7)
> > > > @@ -169,10 +165,13 @@ struct mc13xxx_leds_platform_data {
> > > >  /* MC34708 LED Control 0 */
> > > 
> > > I don't see the line above in the MFD tree?
> > > 
> > > Which commit/branch/repo is this patch based on?
> > 
> > Dependency:
> > linux-next, a59ce6584d (leds: leds-mc13783: Add MC34708 LED support)
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/include/linux/mfd/mc13xxx.h?id=a59ce6584d566847980f9dcad5343cd9856145c8
> 
> Ah, you can't do that, as it will cause conflicts and Linus will
> likely get upset.

So what do we do now? What is the solution?

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
