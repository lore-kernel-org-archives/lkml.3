Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaK0PYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:24:47 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21795 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaK0PY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:24:27 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-2c-547742281b23
Message-id: <1417101862.1805.23.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
Date: Thu, 27 Nov 2014 16:24:22 +0100
In-reply-to: <547740A0.4040700@nod.at>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
 <1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
 <1417101060.1805.21.camel@samsung.com> <547740A0.4040700@nod.at>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+693t2tBtdlcjFTG5Sx8hWLBykJk7pRgYlI9SWXLhXc1K1N
	DYL5kpRvaSLW2mxoZRNRcmlqvrWyTYo5NbcsNkGJGDpdWdpcabp98dv/HH6/c86HQ6CcWSyA
	yBLdEIhF/GwuzsI+rOvNYYfi85Mjl0cJqOxow+GCpQGFtu41HLY9s+PwjXMGg4vFbgxudJcy
	4Mb8EVg9lwQN2hkAXZo+AD9WCKF29Q4OJ/uUOHRWzuJQ6XDgcKqhgwEnhtUInHBbUahZ/orB
	rqHbAOqrhhG4bF5jQIv1JQrrehcALHvyAoHGou8YHDMZGXCy6yEKx/7pfU4G0Qp5FU4/ko9j
	dK/CyqDVnVLa/PoyrX3Oo5v77QhteODG6LKWQYyu+9wC6OnGPPrHty8YPdrowumlwSmcHhlq
	wmmrxY4k+l1hHU8XZGfJBOKIuFRWpslpQnJVzILWVxZUDlSMcsAkKDKGsizZEG/2p0y2Drwc
	sAgO+RRQzslmxFtsAMrUOIZuUWwymnJ2ujz2bjKUevvY7ck4GUmtmgY8jN9mf9Fe75mEkiom
	NdFTvQkRBEYeoNTOmK3IJA9S9yynvPPrUcrYX+px0U33fmMT6r2IRy2VuzDvXl/qT50N8zLB
	lLbNgdYAUrFNUWzDFNswNUBbwR6BNC1Xci1DGBUu4QslUlFGeFqOsBN4/+JXD2h+H6sDJAG4
	u9ipc7Jkjg9fJikU6gBFoFw/dvGJ/GQOO51feFMgzrkqlmYLJDqAEMwAOaglOK72kujTEZPv
	QmIrL6onyj6hwTxHe0i7mGkOHBEZA1d+GuKH958dVctuaZRniob850tFkeM5A0kXjoW5doT/
	/p2SFBRcuy5LtF6K18BQHrek1Tevp8+cYLj+130+gbVvb9y8flqZUpV5Tnu3glWQdjjjaM2K
	tXundkG1puNikkx+FA8VS/j/AbO0umv1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 16:17 +0100, Richard Weinberger wrote:
> Am 27.11.2014 um 16:11 schrieb Lukasz Pawelczyk:
> > On czw, 2014-11-27 at 16:01 +0100, Richard Weinberger wrote:
> >> Am 27.11.2014 um 15:44 schrieb Lukasz Pawelczyk:
> >>> True, the last one is 0x80000000. I did not notice that. Thanks for
> >>> pointing out.
> >>
> >> Isn't this CLONE_IO?
> > 
> > Yes, I was merely noticing out loud that it's the last bit of 32bit.
> > 
> > After close look though the 0x00001000 appears to be unused
> 
> This was CLONE_PID.
> I'm not sure if we can reuse this. man 2 clone states "It disappeared in Linux 2.5.16.".
> Maybe one of the CC'd parties can tell more...

Would really like someone to comment on this. I'd like to avoid creating
a new syscall at this point.

According to clone(2):
CLONE_STOPPED has been removed in 2.6.38 and can be reused.
CLONE_PID as you mentioned has been removed in 2.5.16 but since 2.3.21
it could only be used by boot process (PID 0).

So this was really long time ago and effectively regular user space
cannot use it since 2.3.21.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



