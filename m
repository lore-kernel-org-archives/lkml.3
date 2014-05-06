Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbaEFDsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:48:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbaEFDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:48:08 -0400
Date: Mon, 05 May 2014 23:48:06 -0400 (EDT)
Message-Id: <20140505.234806.682722563142395714.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, iamjoonsoo.kim@lge.com,
        sparclinux@vger.kernel.org, hannes@cmpxchg.org, cl@linux.com,
        penberg@kernel.org
Subject: Re: [PATCH] slab: Fix off by one in object max number tests.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwi7YMSt2k+yES=6HetDxq0aQYSxdmmdbvbn6L9LzE3NQ@mail.gmail.com>
References: <20140505.232550.1139149215179650645.davem@davemloft.net>
	<CA+55aFxSAy2ePfNzFyb7rQ+M6UFxW9rHCMEcQaVbc5zVeNAn-g@mail.gmail.com>
	<CA+55aFwi7YMSt2k+yES=6HetDxq0aQYSxdmmdbvbn6L9LzE3NQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:48:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 May 2014 20:46:32 -0700

> On Mon, May 5, 2014 at 8:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I guess I'll apply both patches directly.
> 
> Applied and pushed out. Davem, I hope this means current -git works
> for you on sparc64 again?

Yes it absoultely should, and I'll double check to make sure.
