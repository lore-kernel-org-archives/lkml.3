Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3F3VwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:52:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44572 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3F3VwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:52:20 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4823.1372623427@turing-police.cc.vt.edu>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
	<20130630181945.GA5171@redhat.com>
	<4823.1372623427@turing-police.cc.vt.edu>
Date: Sun, 30 Jun 2013 23:52:19 +0200
Message-ID: <CA+icZUUHXq-ZBYqgwitrC9Ek8LJZoK=bZQ8CbWppd8zJWx=F9w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High CPU
 usage ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Oleg Nesterov <oleg@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 10:17 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 30 Jun 2013 20:19:45 +0200, Oleg Nesterov said:
>>
>> Not only "__wait_no_timeout(tout) ?:" was wrong, I didn't bother
>> to recheck this logic even after I got the "warning: the omitted
>> middle operand in ?:" reports.
>>
>> Sedat, thanks you very much! Any chance you can try the patch below?
>
> I'm not Sedat, but I had the same problem with rsyslog going nuts,
> and I can confirm that the patch fixes the problem.  (Had to hand-apply
> it, there was some difference of opinion regarding { } on an else)
>

I am... Legend :-).
Thanks for confirmation!

- Yes, it's you (every day Gmail says this to me) "Sedat" -

> Feel free to toss on a Tested-By: if this becomes a separate commit...
>
