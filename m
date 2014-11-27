Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaK0Rij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:38:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30333 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK0Rig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:38:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-88-547761992f5e
Message-id: <1417109911.1805.27.camel@samsung.com>
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
Date: Thu, 27 Nov 2014 18:38:31 +0100
In-reply-to: <871tooy4nc.fsf@x220.int.ebiederm.org>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
 <1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
 <1417101060.1805.21.camel@samsung.com> <87d288zm3a.fsf@x220.int.ebiederm.org>
 <1417104439.1805.25.camel@samsung.com> <871tooy4nc.fsf@x220.int.ebiederm.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHffd+vjug9DkPvAiVLCQQU7OQV8kIIvqsLiS8yKJs6fCAm7bP
	Y0WYmZjloU0xpy3TPCwHlqfSPEdqKW4qalpuZIh5SkvKwzLT7ca7Hzy///N/Lh4eFE5RzrxI
	WZxELhNHi5CA6vvXM3qoUJwY5FW/vIcU12gRWRgrgMTQuIGItmIWkc5lI0V+pJoostWYxiVb
	8+4k+9t50ltnBGRd0wxI/wMpqVvNQGS4uRiR5YdTiBQvLiIyUlDDJUMdJRwyZJqERLPymSIN
	7fcA6cnq4JCV0Q0uGZush0TZtABI+vNXHDJwZ4YiOv0Alww3FEKi2+yxPrGPUaVkIaYoZZBi
	mlSTXKakNp4ZfRvM1FW5MWUtsxym97GJYtIr2yhG+akSMOPq68zP6QmK+aBeR8xS2whi3reX
	ImZybJYT6HBRcCxMEh2ZIJF7Hr8qiJjPfwRjM52S8gx+KUBrlwn4PEwfxQUbrcjCTlhvqNlm
	AU9IlwOc8aUI7AyE9BbAaYMuO2xLe+M/VX3cHbanD+J3T01mRrQXXtW3wh12oD3x+JLCvAjS
	+Xzc315ilijaFXfnTJnb+PQRPJdnoixtvyCeHts0p+H2VoW6FFpOcsNLmeuUpdkOrykNlMXZ
	j+u0izAX0KpdEdUuTbVLKwHwBXCUxIfGstfCpd4erFjKxsvCPUJjpLXA8he/34Dybr8uQPOA
	yMbWaiIhSGgtTmCTpV0A86DIwTbVPzFIaBsmTr4hkceEyOOjJWwX4PD4zinAX9v9sSz2iVWE
	Yq/SN50v5EYpdWHUAXireq5S0lSB1beNopyvPoYr35M6hXqv+2vnfPIDs11C4hBf8TK35aLO
	WHoX+rKnxm16I/9WPzupQMFRF2YCLgVMzE67Ow5rXOsDZK8HTUFtBacb4SZKHNHp58428IVI
	c8aevRxxU0SxEeLDblDOiv8DUU8Ri/UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 10:44 -0600, Eric W. Biederman wrote:
> Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:
> 
> > On czw, 2014-11-27 at 09:42 -0600, Eric W. Biederman wrote:

> >> We are probably going to need to go a couple rounds with this but at
> >> first approximation I think this functionality needs to be tied to the
> >> user namespace.  This functionality already looks half tied to it.

Actually it's not. You can create LSM/Smack namespace without user
namespace and it works properly.

> >> When mounting filesystems with user namespaces priveleges matures a
> >> little more you should be able to use unmapped labels.  In the near term
> >> we are looking at filesystems such as tmpfs, fuse and posibly extN.

Ok, I get the idea now. But still  think it wouldn't do well with the
Smack namespace. It would basically allow you to operate on something
that the administrator did not allowed you to (by filling the labels'
map).

If the user namespace allows such a thing now I was not aware. I'll have
a look.

> I had two points.
> a) Tie the label mapping to the user namespace, then we don't need any
>    new namespaces.
> 
>    Is there a reason not to tie the label mapping to the user namespace?

I remember that I entertained the idea when I started the work on that
and for some reason went against it.

Right now the major issue I see is that LSM by itself is not defined how
it's going to behave. It's up to a specific LSM module.

E.g. within the Smack namespace filling the map is a privileged
operation. So by tying them up you cripple the ability to create a fully
working user namespace as an unprivileged process.

I want to have Smack namespace be able to map its own label without
privileges (as user namespace can do with its own UID) but for now it's
not the case and I'm not sure it will ever be.

With other LSM implementation other limitations might apply.

Besides a use case (with other LSM modules) when someone might not want
to create an LSM namespace might be valid as well.

> 
>    Needing to modify every userspace that create containers to know
>    about every different lsm looks like a maintenance difficulty I would
>    prefer to avoid.

The LSM namespace is only one, it's not like every LSM modules creates a
different namespace. The LSM namespace is created for the LSM module
that is active at the moment. And user space might need to be aware of
them anyway as e.g. Smack requires you to create labels' map. Other
modules might require something different.


BTW: have you read the Smack-namespace readme I pasted in the cover
letter? It describes the idea behind namespace implementation in that
particular module.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



