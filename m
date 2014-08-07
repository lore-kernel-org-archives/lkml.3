Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaHGXfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:35:31 -0400
Received: from ozlabs.org ([103.22.144.67]:34596 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaHGXf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:35:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the modules tree
In-Reply-To: <20140807230342.52e3a52c@canb.auug.org.au>
References: <20140807132017.2ec9e2ad@canb.auug.org.au> <87tx5ocyz3.fsf@rustcorp.com.au> <20140807230342.52e3a52c@canb.auug.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 07 Aug 2014 22:37:50 +0930
Message-ID: <87a97gcus9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> On Thu, 07 Aug 2014 21:07:20 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Ah, crap.  I really hate that macro magic :(
>> 
>> I amended to the minimal fix, so we can pretend that never happened.
>
> How about arch/powerpc/platforms/powernv/opal-dump.c as well?

Hmm, I didn't see that one.

I've done that as a separate patch.

Thanks,
Rusty.
