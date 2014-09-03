Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaICVSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:18:42 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50873 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaICVSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <87k362vsr5.fsf@x220.int.ebiederm.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
	<87vbpm4f4y.fsf@x220.int.ebiederm.org>
	<20140821131257.GA4264@infradead.org>
	<53F5F2AD.5010607@nod.at>
	<87k362vsr5.fsf@x220.int.ebiederm.org>
Date: Wed, 3 Sep 2014 23:18:39 +0200
Message-ID: <CAFLxGvyj01YTwhPJWuAMwJO-QGjHi4UZwhhemDbaPvuEJddhqg@mail.gmail.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 4:09 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> It looks like commit 87b47932f40a11280584bce260cbdb3b5f9e8b7d in
>> git.kernel.org/cgit/linux/kernel/git/ebiederm/user-namespace.git for-next
>> unbreaks libvirt-lxc.
>> I hope it hits Linus tree and -stable before the offending commit hits users.
>
> I plan to send the pull request to Linus as soon as I have caught my
> breath (from all of the conferences this week) that I can be certain I
> am thinking clearly and not rushing things.

*kind reminder* :-)

-- 
Thanks,
//richard
