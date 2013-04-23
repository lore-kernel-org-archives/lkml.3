Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3DWP1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:27:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3DWP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:27:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH 06/10] usb: musb: ux500: add device tree probing support
Date: Tue, 23 Apr 2013 17:27:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, linux-usb@vger.kernel.org
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org> <201304231714.06326.arnd@arndb.de> <20130423151533.GD15177@arwen.pp.htv.fi>
In-Reply-To: <20130423151533.GD15177@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304231727.10696.arnd@arndb.de>
X-Provags-ID: V02:K0:nncZK3ljVE9hvNQdraqnsyjSJPjvx+Ozv+ubzsSOSzr
 FL5sFxNWhrxZvrDsxPMwxUURoiQOrPgFvc9UPGtK4APOTV8juT
 1HqPnRN6/5p3bnRQQnpgv1FHaJNfaW7Gu4d6z8z+V2j1coj7TO
 Q4KSh3/jbdzxD6RH0/JKyJ5EqnfBaKsGeBrMSO1lQ4W+33gN1l
 QhBp1s9djgQappkmG1DQtSqL0WExdo/+ssV9kLqSkT0CNo/1Vo
 jKNf6WuuWXtrYP+1bFJHnqwbeFdyPzLdoiU1u4tYG/OmllhCPL
 kWzwCeEAYZXbrrA/ATR12U2WCsYx1t2aBrThVSh4jMWm6tKmBn
 Mg7IKG0pvSbNxMt+YI78=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Felipe Balbi wrote:
> On Tue, Apr 23, 2013 at 05:14:06PM +0200, Arnd Bergmann wrote:
> > On Tuesday 23 April 2013, Lee Jones wrote:
> > > +Required properties:
> > > + - compatible : Should be "stericsson,db8500-musb"
> > > + - reg        : Offset and length of registers
> > > + - interrupts : Interrupt; mode, number and trigger
> > > + - mode       : One of; "host", "otg", or "peripheral"
> > 
> > I think we don't have any precedent for this combination of "mode" property
> > and contents. You could either try to match ehci-omap.txt and do
> 
> there is dr_mode which other folks are using. Let's use the same thing.

On that topic, should we support the same property in am35x.c and 
musbhsdma.c? They currently use an integer rather than a string.

	Arnd
