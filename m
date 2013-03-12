Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3CLNFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:05:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CLNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:05:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 1/1] asm-generic: move cmpxchg*_local defs to cmpxchg.h
Date: Tue, 12 Mar 2013 13:05:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
References: <1362030843-25354-1-git-send-email-jonas@southpole.se> <513F2124.6060504@southpole.se>
In-Reply-To: <513F2124.6060504@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121305.08691.arnd@arndb.de>
X-Provags-ID: V02:K0:JBTWV2LalLcDXaE4rPfmQrOYF9Kr5m7lMxxbf3jSKPS
 7dCW05wapJpCOcv+QjR7qJhkku0GBev7o+/xNGt97LX7a8/vkg
 tstJ7e3Go/CsGdLC9V6bbc33rwSHZjI1JIClV6gy7sox1E0iCc
 rVJ4hdW1wFFDng3uD9Q3Ia++IwET2SivW/6cg23TaxRuCgqSwJ
 y+UJaSWRRPKK/7E9yeX9XNVtVQyS701AIH97ASGly3UT/3yHyV
 JhTYFZjQWaDYo5Y3mjtcxIJOcxyyetmixHHBR/6I0sN8VkSqOi
 uYUpWMswRbKnhPE8svJieGKyiUjOb6+P7ghJk8f4WAoDsxAfWE
 Hux9jyWXwrvTXNmv6w7k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Jonas Bonn wrote:
> Can you comment on this patch?  This is needed so that the generic 
> asm/cmpxchg.h can be used standalone (i.e. without pulling in atomic.h). 
>   OpenRISC uses the generic asm/cmpxchg.h and things currently don't 
> build without this since linux/llist.h now includes asm/cmpxchg.h 
> standalone.

Looks fine to me, I thought I had replied to this earlier, but I don't
see it in my 'sent-mail' folder now, so I assume I did not.

Please send this as a bug fix through your own tree.

Acked-by: Arnd Bergmann <arnd@arndb.de>
