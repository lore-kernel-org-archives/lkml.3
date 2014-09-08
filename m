Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaIHUr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:47:58 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51643 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaIHUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:47:56 -0400
Message-ID: <540E15F8.2030900@converseincode.com>
Date: Mon, 08 Sep 2014 15:47:52 -0500
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, james.l.morris@oracle.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com>	 <alpine.DEB.2.10.1409060131260.5472@nanos>	 <540A590F.1030407@converseincode.com>	 <alpine.DEB.2.10.1409061152090.5472@nanos>	 <540BBD9E.6050708@converseincode.com> <540D73C9.3000906@samsung.com>	 <540DA051.2030701@converseincode.com> <1410183821.8054.27.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1410183821.8054.27.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 08:43, Mimi Zohar wrote:
>
> Behan, thank you for the explanation.
No worries. I should have explained better. My apologies.

> The same snippet of code used
> here, and elsewhere in the kernel, is taken from the crypto subsystem.
> Once it is resolved in the crypto subsystem, the same solution should be
> propogated.
>
> Mimi
Indeed that is my intention. I have tglx's suggested solution coded 
already. Just doing a bunch of allyesconfig builds to confirm all is 
compiling correctly.

I will post all patches as a single patch set this time (posted to all 
concerned).

I will repeat the explanation as well with the new patch set so everyone 
else in other subsystems sees those reasons as well.

If this works for everyone I'll also go back and update the crypto 
patches for the subsystems that have already accepted my previous patches.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

