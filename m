Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaAON2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:28:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaAON2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:28:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] headers_check: special case seqbuf_dump()
Date: Wed, 15 Jan 2014 14:28:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
References: <1389782899.2128.15.camel@x220>
In-Reply-To: <1389782899.2128.15.camel@x220>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401151428.42113.arnd@arndb.de>
X-Provags-ID: V02:K0:/rXDFiQ2bJdi09RM8cNDmb+vgjQDmcFRYLE0Odcr2ZA
 0mfeun0SPfspg36j2Pb38XQz3D0l0GFVIQNQ4Pdz4QNMd8xUgH
 T0uCcy9NZXSFHdOW3PvIJZtZCbpnioE+UawRWIBE8EEul1RzSO
 o2LG3nODgiwnG6UQbgUG6YUprHHOfFs6wUybin7RMC/E2AyISJ
 W0fbhy5vpnbYtzOkVSk2XjhC22RB1sRmtnQTr1s6rdahENfJTT
 KgqADiGQI997Hywuqeam0l5a6r+4w6W1aWXrVnv71d+FK5b8BH
 rU279ClNAo171E3M3JoeD6+n7c3L875Y4TzOErEFTsAodSdsem
 eNOMhgufXOgxccfj4clE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Paul Bolle wrote:
> "make headers_check" warns about soundcard.h for (at least) five years
> now:
>     [...]/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
> 
> We're apparently stuck with providing OSSlib-3.8 compatibility, so let's
> special case this declaration just to silence it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks so much! This one has been bugging me for ages.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Who would be the right person to apply this? Adding Andrew and Michal
to Cc.
