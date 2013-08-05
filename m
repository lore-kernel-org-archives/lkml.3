Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3HESBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:01:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3HESBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:01:50 -0400
Date: Mon, 5 Aug 2013 19:56:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805175623.GB8461@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130805132948.GA14942@redhat.com> <CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com> <20130805143935.GA18100@redhat.com> <CAMP44s0Q5fCcAwjPWaiz8uVE+BAnQ=YOBxtqNXR6XT1KBApFng@mail.gmail.com> <20130805171142.GA6978@redhat.com> <CAMP44s26f-AFWyxgWEyF50N6wntwT-UDHS4ZdSnZbagj+Rai7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s26f-AFWyxgWEyF50N6wntwT-UDHS4ZdSnZbagj+Rai7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Felipe Contreras wrote:
>
> Would it be possible to just revert that patch for v3.11, and fix it later?

Sure, but it would be nice to investigate.

I think we have the time for revert, this patch was added after 3.10
so I hope we can always revert it before 3.11.

Felipe, I'll try to make a stupid debugging patch tomorrow, perhaps
you can test it...

Oleg.

