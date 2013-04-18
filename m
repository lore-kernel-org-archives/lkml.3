Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967351Ab3DRMX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:23:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739Ab3DRMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:23:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree parsing support
Date: Thu, 18 Apr 2013 14:23:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <201304181337.32700.arnd@arndb.de> <20130418114756.GE27903@gmail.com>
In-Reply-To: <20130418114756.GE27903@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181423.38900.arnd@arndb.de>
X-Provags-ID: V02:K0:iWhySpMnPgg0neuQZB56uR+0oUqca8LAz904l1Wf17m
 nfItyHdFHLEB2okYZvi09dj6lYM13UuRRceX/OKqhLbct5XbpW
 ABuJn0WOjXWR4NMVm/f8u6O5nzHjCmCDMHIKZC9wAuqR3H6B4M
 b/VMcQE/vXL9YhdWuBNvwlsHSWmJvbAhjJc3RG8nFvrCnkkoph
 YKP9rkfKAFmscUim1f+WN1o+YvjueLGiV27V16TRY+rUOZtp/G
 bwKdexmlq4gFRP43yCiKIdbhV6vuiRwBbjYCA3hDefyeukhtRZ
 aI96SMVkdSQ52Y+xmuV3H+BgDsWLHspW3iAAY9WWiUWKGKoNdJ
 7Ra83pb4uB/wXIX2EpXU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> > Yes, that's probably better and more in line with what the other
> > drivers do. You could also put the fixed_chan last if that helps.
> 
> I'd rather keep the flags as the final cell if it's all the same to you?

Ok, no problem.

> > I would still like to get a confirmation that we actually still
> > require the fixed channel assignment, since it's just used
> > in one driver, and that might only be needed for some buggy
> > hardware revision if we're lucky.
> 
> Unfortunately not:
> 
> `git grep "\.use_fixed_channel" <internal_kernel> | grep true | wc -l`
> 8

I see.

	Arnd
