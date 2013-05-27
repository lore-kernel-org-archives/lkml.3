Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3E0Kby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:31:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0Kbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Mon, 27 May 2013 12:31:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305262323.29519.arnd@arndb.de> <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
In-Reply-To: <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271231.40693.arnd@arndb.de>
X-Provags-ID: V02:K0:dNd5Q6iIl1ZrtXqySWeDtOpaxF7Nr12F0+JtZjEbAV6
 tIza3Ne18q1kr2lywF92A4o/SclT1OvSm0/NbH9EIRVGTP755r
 adkdLDXlERsD4z3dIrPiZYCuyzjMMbv+Aev+JWrhPd4uqkqS2z
 br40JLy1oaAe3GGz1sFkYEAY71CaYKwEvFB6jv9K2+/Xs78i2U
 kcOw4jnajWB4lmR+5+y5ccpG7fAwT+YKcFSNv6lIIEZyoH6VDH
 ecf2JoeYgEqevrNrzgHSMuq9TI3HQN+M8nYRKzQtashPchXbrM
 Hmzc8/+0gS8xVDKNGwRMwqZrgOaLYi7O/O7r4CQkKI57XsVVGm
 ZqRlOITtGUwIrgglUc/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, Daniel Tang wrote:
> > The one remaining bit that sticks out is the clcd platform data. As I
> > said before, I won't require you to convert that to DT in order to
> > get your code merged, but I'd also really like to see that happen,
> > as we will also need that to get rid of auxdata on the ARM reference
> > platforms (integrator, versatile, realview, vexpress).
> 
> How would you like me to convert the platform data to DT? AFAIK, the clcd
> driver isn't aware of DT so the only way is to use the AUXDATA right now.

Linus Walleij mentioned on IRC that Pawel Moll already posted a series
that adds DT support for clcd:

http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html

The series does a few more things, but you can probbly split out the
parts you need and base on that.

	Arnd
