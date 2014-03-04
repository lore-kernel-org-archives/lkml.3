Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbaCDLYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:24:42 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:44850 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbaCDLYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:24:41 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?VGhvbWFzIEdsZWl4bmVy?= <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gaXJxOiBFeHBvcnQgc3ltYm9sIG5vX2FjdGlvbigp?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 04 Mar 2014 15:15:33 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1393931733.877810306@f371.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <alpine.DEB.2.02.1403041203540.18573@ionos.tec.linutronix.de>
References: <1393656316-26757-1-git-send-email-shc_work@mail.ru>
 <alpine.DEB.2.02.1403041203540.18573@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24BOlqM003171

Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº,  4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 12:05 +01:00 Ğ¾Ñ‚ Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 1 Mar 2014, Alexander Shiyan wrote:
> 
> > This will allow to use dummy IRQ handler no_action() from
> > drivers compiled as module. For example, dummy handler is could
> > be used for drivers that use ARM FIQ interrupts.
> 
> And why exactly requires a driver which uses ARM FIQ interrupts the
> no_action implementation?

FIQ Interrupt handler is not used in this function. In FIQ case this is just a
dummy declaration. Real handler is assigned by using the set_fiq_handler().

> > @@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
> >  {
> >  	return IRQ_NONE;
> >  }
> > +EXPORT_SYMBOL(no_action);
> 
> EXPORT_SYMBOL_GPL if at all.

v2?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
