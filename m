Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163293Ab3DFLv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:51:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163289Ab3DFLvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:51:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Sat, 6 Apr 2013 13:51:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304041112.25780.arnd@arndb.de> <8FB21B56-58BC-4530-8C7A-71A32856210D@gmail.com>
In-Reply-To: <8FB21B56-58BC-4530-8C7A-71A32856210D@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304061351.00889.arnd@arndb.de>
X-Provags-ID: V02:K0:O18BLVMsKTIGEs6pa1Nv3GBN1zvRJ/EJFN8KMvbJzGT
 u2l7kn+mvTqCQzjKuS+fIhIZtGbpGAKj7wcgtIuRyhlH0UWypg
 YAyGDKEIMB9mSKKLyMobxlDWg4ZQwBwSOSeCLaZMu43wSGG4qP
 DasXFJgSSjEtwoLzKVKaqYv/wWlL6id9quhGN3EADQbSygaIsW
 QddgcGUHCrdjnj4xk5WBfF5SMp4YUgA4ki0HXgSHe68XzjzqE4
 KQ39Y5vX+q6noU/PfIHDRZ4jnuOWKkBZLAh2WZJoVuoCoZ7iAi
 6d0Nr3/hal0H/Fyy/bvLOMoxal1pIB/smrT0dhk1H96DqrtYYn
 NEBcUb0ZFTLJxXEkCBjk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 April 2013, Daniel Tang wrote:
> Hi,
> 
> First of all, thank you for your comments!
> 
> On 04/04/2013, at 10:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > For new platforms, we want to have only the absolute minimum amount of
> > code in arch/arm and move everything else into drivers. However, that
> > is only possible using device tree. It should not add any significant
> > complexity to your code, and you can easily bundle the device tree blob
> > with the kernel.
> 
> Given that most of your comments described some very fundamental changes
> (esp switching to DTB) to the structure of our port, we've decided we'll
> probably start from scratch and fix the issues you outlined as we
> reimplement our platform.
> 
> At the moment, we're working on getting a basic DTB-booting kernel working
> so our next patch will be starting from basics.

Ok, whichever way you prefer. If you have questions while working on this,
feel free to join #armlinux on irc.freenode.net, there are usually other
people working on the same things.

	Arnd
