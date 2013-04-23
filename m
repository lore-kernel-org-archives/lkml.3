Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3DWTlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:41:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3DWTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:41:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 21:41:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-15-git-send-email-arnd@arndb.de> <4082180.JXNz6TsAKc@ax5200p>
In-Reply-To: <4082180.JXNz6TsAKc@ax5200p>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232141.04123.arnd@arndb.de>
X-Provags-ID: V02:K0:bk54y0dFlT5MvS3Y2ldhOIz503H2bx9XyHvEfasHPSS
 +4inzdqaA8ZkyGSi3RoCIIqlwuT96MwFanb5stDBipCZugSEnb
 wWV9MW5UxGwl1l629mOrDUt4CptrtL4ITgiEKQbMJkxa8Fw6Hu
 XTRjQmvLYXPj1JewP/jle4e+zHb4MhP4SDUG0lUoxPp7H2i9tA
 dgHBAzqigpY6ljdX7TygUkkLxOSDqtwAuGZX32arOR3NJr768y
 89V8flekpPwHigvh9eBeJsiIkGYumEX3DvNkXp9CJzUfwIWjL8
 TcmARacaWMkPWgozC/7CYPtJuAdam1ISN2fE6mgGx2gENrgonS
 6NXh2UMI7ADGCqd2SDA8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Marc Dietrich wrote:
> On Tuesday 23 April 2013 18:30:46 Arnd Bergmann wrote:
> > The serio code can be a loadable module, which in turn means that nvec
> > also has to be a module, so mark it as "tristate" in Kconfig.
> 
> oh, I didn't saw this randconfig error posting. NVEC isn't prepared for 
> modularized builds yet (it's on the TODO list though). So better say SERIO=y 
> here. Looking a bit closer, there is other stuff which can also be a module 
> (GPIOLIB, I2C, ...) so these also need a =y.

What is the problem with building it as a module? It looks all fine in that
regard.

I also did not see any problems with the other symbols, but that may be
because they get turned on as built-in even in allmodconfig. Marking it
as tristate certainly avoids the problem altogether.

> Should a post a patch?

If you have follow-on patches, they need to go on top now, since Greg
already took this patch.

	Arnd
