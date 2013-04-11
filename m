Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922Ab3DKEBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:01:00 -0400
Received: from ozlabs.org ([203.10.76.45]:49559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3DKEA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:00:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Cohen <david.a.cohen@intel.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mark.gross@intel.com
Subject: Re: [PATCH v2] MODSIGN: do not send garbage to stderr when enabling modules signature
In-Reply-To: <51659024.4010405@intel.com>
References: <1365543543-17522-1-git-send-email-david.a.cohen@intel.com> <87k3oa65hx.fsf@rustcorp.com.au> <51659024.4010405@intel.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 11 Apr 2013 13:29:09 +0930
Message-ID: <87hajd4t0y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Cohen <david.a.cohen@intel.com> writes:
> On 04/10/2013 03:32 AM, Rusty Russell wrote:
>> David Cohen <david.a.cohen@intel.com> writes:
>>> openssl may send garbage to stderr when generating X.509 key pair for
>>> modules signature regardless there was an error or not. It makes more
>>> difficult to create scripts based on kernel error/warning messages.
>>>
>>> When compiling kernel with -jN (N > 1), all warning/error messages
>>> printed while openssl is generating key pair may get mixed dots and
>>> other symbols openssl sends to stderr. This patch makes sure openssl
>>> logs go to default stdout.
>> Ah!  Not garbage, but it writes progress dots and status messages to
>> stderr?
>>
>> I trimmed your commit message as shown below.
>
> Thanks! The new commit message looks fine.
> But it's not the dots. It prints the whole logs to stderr, but the dots 
> are more likely to get mixed.
>
> Br, David

Seems like Linus didn't bite, so I've put it in my modules-next tree.

Thanks,
Rusty.
