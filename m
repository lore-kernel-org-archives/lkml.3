Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161524AbaJaAja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:39:30 -0400
Received: from ozlabs.org ([103.22.144.67]:38592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161458AbaJaAj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:39:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>, Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] hw_random: fix unregister race.
In-Reply-To: <20141021141745.GA18511@gondor.apana.org.au>
References: <1411043867-21109-1-git-send-email-akong@redhat.com> <1411043867-21109-5-git-send-email-akong@redhat.com> <20141021141745.GA18511@gondor.apana.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Oct 2014 10:28:00 +1030
Message-ID: <87y4rx860n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Thu, Sep 18, 2014 at 08:37:45PM +0800, Amos Kong wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> 
>> The previous patch added one potential problem: we can still be
>> reading from a hwrng when it's unregistered.  Add a wait for zero
>> in the hwrng_unregister path.
>> 
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> You totally corrupted Rusty's patch.  If you're going to repost
> his series you better make sure that you've got the right patches.
>
> Just as well though as it made me think a little more about this
> patch :)

OK Amos, can you please repost the complete series?

Thanks,
Rusty.
