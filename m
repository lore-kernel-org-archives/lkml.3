Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3GXR7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:59:47 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56568 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3GXR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:59:45 -0400
Date: Wed, 24 Jul 2013 14:59:38 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for Jul 24 (media/usb/stk1160)
Message-ID: <20130724175937.GC3353@localhost>
References: <20130724163254.f026790fa2fe367f85969901@canb.auug.org.au>
 <51F00FC9.103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F00FC9.103@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Wed, Jul 24, 2013 at 10:32:57AM -0700, Randy Dunlap wrote:
> On 07/23/13 23:32, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130723:
> > 
> 
> on x86_64:
> 
> 
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x414e77): undefined reference to `snd_card_create'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x414f02): undefined reference to `snd_ac97_bus'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x414f3f): undefined reference to `snd_ac97_mixer'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x414f64): undefined reference to `snd_card_register'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x414f8f): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `stk1160_ac97_unregister':
> (.text+0x414fd8): undefined reference to `snd_card_free'
> 

If I remember correctly this is the same issue you reported on May,
and that got solved with a patch by Mauro:

https://patchwork.linuxtv.org/patch/18284/

Seems the patch never got merged.

@Mauro: Can you apply the patch you proposed in the above link?

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
