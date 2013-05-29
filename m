Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3E2MrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:47:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3E2MrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:47:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Wed, 29 May 2013 14:46:27 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305271231.40693.arnd@arndb.de> <146FF7AD-650E-4706-B9E1-53C2693D1D0D@gmail.com>
In-Reply-To: <146FF7AD-650E-4706-B9E1-53C2693D1D0D@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305291446.28169.arnd@arndb.de>
X-Provags-ID: V02:K0:y164osvPxnaa6EnktnRNqQuAutREAjEYilTEPXe1jtj
 IexLLsvxSearD2jqB+CS8mZ5XzldUuOniaptzqYcfisNO7x4qA
 /LU1OmZLiEX2KjQNabT1qg4N9GlDMJtasbAgUFYGaDr7I9HHcI
 rZ9Z5vubiyWsC2eGxOwdXQiW8Vt34xCHppKeMzYfp3Q4q9Tsf5
 JDskL/TJn4AFThiLAOjQ1C1RXbVsubnGVR4RDcuEYOyO7DLOVv
 CbE8ZBW8pg50IK20vZnRRsjeHzo2w1+jwIksvHxS92dFLljzxp
 wTOTgopGzsjT0EAM1NwB9Al+NeT3TNKn4GeEdgza1rzTIxofLj
 66UB/3xCIVM9Fq08WQ20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 May 2013, Daniel Tang wrote:
> On 27/05/2013, at 8:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Monday 27 May 2013, Daniel Tang wrote:
> >>> The one remaining bit that sticks out is the clcd platform data. As I
> >>> said before, I won't require you to convert that to DT in order to
> >>> get your code merged, but I'd also really like to see that happen,
> >>> as we will also need that to get rid of auxdata on the ARM reference
> >>> platforms (integrator, versatile, realview, vexpress).
> >> 
> >> How would you like me to convert the platform data to DT? AFAIK, the clcd
> >> driver isn't aware of DT so the only way is to use the AUXDATA right now.
> > 
> > Linus Walleij mentioned on IRC that Pawel Moll already posted a series
> > that adds DT support for clcd:
> > 
> > http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html
> > 
> > The series does a few more things, but you can probbly split out the
> > parts you need and base on that.
> 
> Would it be fine if I waited until CLCD DT patch gets into mainline instead?

Yes, you can do that too, I was only asking whether you were interested
in helping out here.

	Arnd
