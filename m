Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3DLKs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:48:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3DLKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:48:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
Date: Fri, 12 Apr 2013 12:48:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
References: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com> <201304121008.51300.arnd@arndb.de> <CACRpkdatbhais8gP3rTRkz0Y1v816Uz8KL6ZhDsh+ByfbjXuxg@mail.gmail.com>
In-Reply-To: <CACRpkdatbhais8gP3rTRkz0Y1v816Uz8KL6ZhDsh+ByfbjXuxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121248.54005.arnd@arndb.de>
X-Provags-ID: V02:K0:WQEfm58F9GYa2J3tZiOjIsTn+W6o0mNekm1X5PcOvta
 zdDDO/6LKbUFU6V6oZxBr/Iv7n8kkjyaxOarN5WFf4qHd3Bp2b
 5yzgv7U+8v/r+VRAC/bW7b7Lf0vioNgmicog8hUqWJnXJxjuOi
 psEkduNencp7M2LFAK2SdvEW67FLSUtjPcnJn0oUDjeb0yq5ZV
 ILS6kteycxO35oQHxGkU6WdNvbn4QKrbxphYs3S/quEM12TO95
 uf5voFWtVZ+0gM86wYRaEqYwu96PNOdcVDTQnPoMIO+yxo8D56
 xabIOWS84ba2+OBK00uACcv7YKHsnZYcSFR+OXUwihjOpHkFvW
 EryBClOWCJbqW3rBpg/w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 April 2013, Linus Walleij wrote:
> On Fri, Apr 12, 2013 at 10:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 12 April 2013, Linus Walleij wrote:
> 
> >> Actually, well, this one IRQ (the one I start to pass) is already
> >> domain-mapped to the global IRQ numberspace, so that one will
> >> be correct.
> >
> > I don't know if we're talking about the same thing here.
> >
> > My point was that passing a domain-mapped IRQ number into mfd_add_devices
> > with another domain will result in the attempt to map that number into
> > another domain, which does not work.
> 
> Ah, yes you're right ... now I need to find some other way
> to pass this resource ... hm.
> 

What is it actually needed for? In the code I'm looking at in linux-next
it only gets passed to a function that ignores it.

	Arnd
