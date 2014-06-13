Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaFMBIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:08:12 -0400
Received: from ozlabs.org ([103.22.144.67]:42013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaFMBIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:08:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Dooks <ben@simtec.co.uk>, Brian W Hart <hartb@linux.vnet.ibm.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Christian Engelmayer <cengelma@gmx.at>,
        Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Lindar Liu <lindar_liu@usish.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Simon Wood <simon@mungewell.org>, Vincent Sanders <vince@simtec.co.uk>
Subject: Re: [PULL] modules-next
In-Reply-To: <20140612112715.GX5099@sirena.org.uk>
References: <877g4oau2s.fsf@rustcorp.com.au> <20140611105503.GG5099@sirena.org.uk> <87y4x2q5qr.fsf@rustcorp.com.au> <20140612112715.GX5099@sirena.org.uk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 13 Jun 2014 10:33:20 +0930
Message-ID: <87a99hpqnb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@kernel.org> writes:
> On Thu, Jun 12, 2014 at 10:55:00AM +0930, Rusty Russell wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> > if you need to respin - please do send patches to maintainers.
>
>> If the address in drivers/regulator/virtual.c is incorrect, please
>> update it:
>
>>  Subject: [PATCH 5/9] drivers/regulator/virtual: avoid world-writable sysfs files.
>>  To: linux-kernel@vger.kernel.org
>>  Cc: Rusty Russell <rusty@rustcorp.com.au>, Mark Brown <broonie@opensource.wolfsonmicro.com>
>>  Date: Tue, 22 Apr 2014 13:03:28 +0930

> The main people to hit are subsystem maintainers - driver authors have
> often vanished or don't really respond to upstream e-mail, though of
> course they should also be included.

Fair enough.  There's a limited amount of effort I go to in a sweep like
this, unless I'm really worried about a particular patch.  lkml (used to
have?) a limit on how many people you could CC so I tend to trim.

So, did you queue a patch to fix your email address in
drivers/regulator/virtual.c?

Thanks.
Rusty.
