Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3BLOvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:51:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19723 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760056Ab3BLOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:51:10 -0500
Message-ID: <511A569B.7050603@parallels.com>
Date: Tue, 12 Feb 2013 18:50:03 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andrew Vagin <avagin@parallels.com>, mtk.manpages@gmail.com,
        David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com> <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com> <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com> <511905D7.3040209@parallels.com> <CAK1hOcNOYRWwrwZEpVza1CTSL_mHEj-Ur577QRnBNkOmdb=Bdw@mail.gmail.com>
In-Reply-To: <CAK1hOcNOYRWwrwZEpVza1CTSL_mHEj-Ur577QRnBNkOmdb=Bdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Process checkpointing needs to bite the bullet and
>>> create its own API instead.
>>
>> This is bad approach as well. What we should do is come up with a sane
>> API that makes sense without the checkpoint-restore project _when_ _possible_.
> 
> Coming up with a sane API in general isn't easy.

That's what we've put the linux-api@ in Cc for ;)

[snip]

> Compared to this, ptrace-attaching to the process
> and then reading from /proc or issuing a new ptrace request
> looks much cleaner.

Sure it does! Also note, that it also looks much cleaner than the
fancy /proc/pid/checkpoint thing you propose.

> My opinion, of course.

Thanks,
Pavel
