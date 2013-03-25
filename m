Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab3CYVt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:49:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab3CYVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:49:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use module_platform_driver
Date: Mon, 25 Mar 2013 21:49:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
References: <201303151807.14074.hartleys@visionengravers.com> <201303161457.24825.arnd@arndb.de> <5145095D.3010304@gmail.com>
In-Reply-To: <5145095D.3010304@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303252149.16960.arnd@arndb.de>
X-Provags-ID: V02:K0:6goImgU4J4HS3H8ZMLiMu+Qoc3NgNOlE/otP0O2vL07
 2cW0XZ8l9073WUwPZplgLl2YrHy1N3Dj6Lb5WwUolNmGxhGg6a
 9ePKO8dOWvQedWcPXETfaLBl5qKpkLNILXgXNQX4i/uKb6MQ28
 2IVjdThbB91tDnMcwN8r3+kATLY3cd/8pJZApBsC4JL+zLQDRY
 2+tvPTcLWI1WRpAGdNd2kOC7I6KKSKaH41nJs4cHZGLBKVivrl
 0nmDyv5LRYPzvnG837JNfviV72UrvA9sKtOUOAiIMV4xNYe2bv
 CLyeFvapj4Ass78YuSXH7k4pGeto3jtIq16eLFH92zeO6/6NJs
 VRXFDsUNhGg7DydLUPLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 March 2013, Ryan Mallon wrote:
> On 17/03/13 01:57, Arnd Bergmann wrote:
> 
> > On Saturday 16 March 2013, H Hartley Sweeten wrote:
> >> Remove the __init tags from the ep93xx_pwm_probe() and
> >> ep93xx_pwm_remove() functions to fix the section mismatch
> >> warnings.
> >>
> >> Use module_platform_driver() to remove the init/exit boilerplate.
> >>
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ryan Mallon <rmallon@gmail.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 
> For the whole series:
> 
> Acked-by: Ryan Mallon <rmallon@gmail.com>
> 
> Not sure if I should take these in my tree, or if they should be
> handled by the respective subsystem maintainers. Arnd?

Doesn't matter much, as there are no dependencies. The default would
be to ask the subsystem maintainers to put them into their trees.
If that doesn't happen for some reason, I can take them through the
arm-soc tree as a fallback.

	Arnd
