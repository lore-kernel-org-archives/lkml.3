Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbaCSJFb (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 19 Mar 2014 05:05:31 -0400
Received: from f123.i.mail.ru ([94.100.178.187]:39722 "EHLO f123.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbaCSJF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:05:28 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: =?UTF-8?B?bGttbA==?= <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?QnJ5YW4gV3U=?= <cooloney@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWZkOiBtYzEzeHh4OiBNb3ZlIGRlZmluaXRpb25zIG91?=
 =?UTF-8?B?dCBvZiBzdHJ1Y3R1cmVz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 19 Mar 2014 13:05:25 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1395219924.503252896@f123.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140319085144.GB31687@lee--X1>
References: <1394867287-14074-1-git-send-email-shc_work@mail.ru>
 <CAK5ve-+RtBC33R6Kvy8b8ducXUE4=PcJtNrURAvA3fdU_7+SZA@mail.gmail.com>
 <20140319085144.GB31687@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s2J95jNf002291

Wed, 19 Mar 2014 08:51:44 +0000 Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> On Tue, 18 Mar 2014, Bryan Wu wrote:
> 
> > On Tue, Mar 18, 2014 at 2:40 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > >> > > > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > >> > > > > ---
> > >> > > > >  include/linux/mfd/mc13xxx.h | 22 ++++++++++++----------
> > >> > > > >  1 file changed, 12 insertions(+), 10 deletions(-)
> > >> > > > >
> > >> > > > > diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
> > >> > > > > index a326c85..d63b1d3 100644
> > >> > > > > --- a/include/linux/mfd/mc13xxx.h
> > >> > > > > +++ b/include/linux/mfd/mc13xxx.h
> > >> > > > > @@ -117,10 +117,6 @@ struct mc13xxx_led_platform_data {
> > >> > > > >
> > >> > > > >  #define MAX_LED_CONTROL_REGS 6
> > >> > > > >
> > >> > > > > -struct mc13xxx_leds_platform_data {
> > >> > > > > -     struct mc13xxx_led_platform_data *led;
> > >> > > > > -     int num_leds;
> > >> > > > > -
> > >> > > > >  /* MC13783 LED Control 0 */
> > >> > > > >  #define MC13783_LED_C0_ENABLE                (1 << 0)
> > >> > > > >  #define MC13783_LED_C0_TRIODE_MD     (1 << 7)
> > >> > > > > @@ -169,10 +165,13 @@ struct mc13xxx_leds_platform_data {
> > >> > > > >  /* MC34708 LED Control 0 */
> > >> > > >
> > >> > > > I don't see the line above in the MFD tree?
> > >> > > >
> > >> > > > Which commit/branch/repo is this patch based on?
> > >> > >
> > >> > > Dependency:
> > >> > > linux-next, a59ce6584d (leds: leds-mc13783: Add MC34708 LED support)
> > >> > >
> > >> > > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/include/linux/mfd/mc13xxx.h?id=a59ce6584d566847980f9dcad5343cd9856145c8
> > >> >
> > >> > Ah, you can't do that, as it will cause conflicts and Linus will
> > >> > likely get upset.
> > >>
> > >> So what do we do now? What is the solution?
> > >
> > > Don't worry about it. Bryan and I should be able to sort something out.
> > 
> > I lost the context here.
> > 
> > I merged Alexander's patch as a59ce6584d566847980f9dcad5343cd9856145c8
> > which modified the mc13xxx.h. But all things are related to LED driver
> > and only add several lines. Next time I will ask Lee to give an review
> > and ack.
> > 
> > So probably this patch has to wait for
> > a59ce6584d566847980f9dcad5343cd9856145c8 merged.
> 
> Yes, I think this is the best idea.
> 
> Alexander, can you re-send this patch with my Ack after the next merge
> window please?

Sure.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
