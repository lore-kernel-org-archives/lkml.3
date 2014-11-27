Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaK0QH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:07:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27228 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaK0QHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:07:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-47-54774c3989b7
Message-id: <1417104439.1805.25.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dario Faggioli <raistlin@linux.it>, Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
Date: Thu, 27 Nov 2014 17:07:19 +0100
In-reply-to: <87d288zm3a.fsf@x220.int.ebiederm.org>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
 <1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
 <1417101060.1805.21.camel@samsung.com> <87d288zm3a.fsf@x220.int.ebiederm.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHffe9+75NW30tjTcDy1lUUh4r3qIioov3QqKDUlakU5eKm9Mt
	NbsQ05TQrNRMm4eGZmoZkoeV5rlSI/GYM80TioXk1DSabpS1rQvvfvD8/v/nuXh4lHAK2vNC
	w69JFOFiqYi2hh//tGv3HfKK8XZLzeLjvIpyGs8OZlN4TGOgcfnTGRq3LIxDPJdghHhVc4vB
	q9/34rtTZ3FH1TjAK2V1AHemynCV/jaN++vyaLxwZ5LGeTodjQeyKxjc16zm4D7jKIXLlr5A
	XNOUBHB7WjMHL2kNDB4craZwZu0swMlPXnJw181vEHf3dDG4v+YRhbt/t3OPOxBVfBpNcuN7
	IalVjTJEXRlFtG98SVWpMymqn+GQjhwjJMkljZBkfi4BZKggkvyYHobkQ8EKTeYbB2jyvqmQ
	JqODM5zTthetjwRJpKHREoXrMX/rkN5XkzAief317OpVJh5k2KQAPg+x+9HDxQbGwptRz1gF
	nQKseUK2GKAy3QTXNBCyqwC1jLAmFrAeKP3dc2jiTewu9Pax0RymWTek72mgTGzLuqKh+Qxz
	EcVm8VFnk9osQXYnGikYpE3MZz3RxPI0Y9lWSKHs8RpzK/WvNaOgkLKc5IzmU1agZfNGtJw5
	9t/ZhqrKddR9wKrWRFRrNNUaTQ2oZ8BOEhUYoQwIlrm7KMUyZVR4sEugXFYJLI/x8zUoajvc
	ClgeEK0T+E9Fewu54mhlrKwVIB4lshUkHI3xFgqCxLE3JAq5nyJKKlG2Ag6Pbx8PLmjKPx28
	mlHs6eMjExhO5CsT51ThQXaRqTYH6j12a3KcEvK3n6cc43g5xrAdZyATN9Ir/LolptLrkr2V
	+5zTQJuO8s1Kt1mxalfLE88NOJwqhYbo3D0vTrJggzZsuOcB2Sq/57r8y8NDrycy3eWkKyHz
	izmO3AC/zFmpY1+RCCpDxO7OlEIp/gusTwpt9gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 09:42 -0600, Eric W. Biederman wrote:
> Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:
> 
> > On czw, 2014-11-27 at 16:01 +0100, Richard Weinberger wrote:
> >> Am 27.11.2014 um 15:44 schrieb Lukasz Pawelczyk:
> >> > True, the last one is 0x80000000. I did not notice that. Thanks for
> >> > pointing out.
> >> 
> >> Isn't this CLONE_IO?
> >
> > Yes, I was merely noticing out loud that it's the last bit of 32bit.
> >
> > After close look though the 0x00001000 appears to be unused
> >
> >> > Any suggestion on what can be done here? New syscal with flags2?
> >> 
> >> I'm not sure. But a new syscall would be a candidate.
> 
> We are probably going to need to go a couple rounds with this but at
> first approximation I think this functionality needs to be tied to the
> user namespace.  This functionality already looks half tied to it.
> 
> When mounting filesystems with user namespaces priveleges matures a
> little more you should be able to use unmapped labels.  In the near term
> we are looking at filesystems such as tmpfs, fuse and posibly extN.

I presume you are referring to the Smack namespace readme where I
mentioned mounts with specifying smack labels in the mount options, not
to the quote above?

I was referring the to the check here that has been changed to
smack_ns_privileged() using ns_capable():
http://lxr.free-electrons.com/source/security/smack/smack_lsm.c#L462

And you can't use an unmapped Smack label inside the namespace, this
would be completely against its idea.

Anyway, at this point I'm more interested in the LSM namespace. I'll be
doing an RFC for Smack namespace later.

Unless I misunderstood your mail.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



