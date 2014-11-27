Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaK0Ofj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:35:39 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33641 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaK0Ofg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:35:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c1-547736b2b02a
Message-id: <1417098928.1805.15.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
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
        Davidlohr Bueso <davidlohr@hp.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
Date: Thu, 27 Nov 2014 15:35:28 +0100
In-reply-to: <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUiTYRiGe7/389u34eBLrV4MMhYmSJlK2luK1NkLQUh5oic1danl1Dan
	GRTLTMz/MlrOYWNpakgzp+L/LzolUadNU1ErsVpmKmr+rFrNnXh2PzzXfd/PwcNCFwvtzsYl
	JEtkCeJ4ESOg3/01jp2sDUwN8+2oPII1+moG/5hQQTzbsMPg6lcWBnetzNG4bM4V/0y30tjW
	kMHDtsUTOH/+Mu43zAG8XdUM8GCOFBs2sxg81qxh8EruZwZrlpYYbFbpeXi0U0vhUesMxFVr
	0zSu73gIsDGvk8Jr4zs8PDFTB/HK4xoGZ5a9pfDQ/a80Hh4Z4uGx+mKIh/8Ync57ELUyjyEl
	ShNNmtQzPKKtVZDxlnDS3NBEEUOlN3nZaqFI/3MrTTIr2mlS9KECkNWFKZoMlG4zZLndzJDe
	Dh1DZiYsVKhbhCA4WhIflyKRnQq5JohtrFGBpEfM7fqWbKgE03Q24LOIO41qMkw8hz6IRmb1
	TDYQsC5cOUCqyUbKMdgAelOsAnZKyPkj26Rt1+HKeaGeF9ZdzXC+aHOkDdq1GxeAdBoVtJsh
	18VHTwc1TvYFzXmiuop0yq753BW0vlpCOxoGASo063eT4P/UJ6U66LjJGy1nb9OO5v1oq2iW
	djAeyFC9BAsBp95jUe/B1HswLYCvwQGJIipJHhkj9feRi6VyRUKMT1SitBY43mOjEZT3nesG
	HAtEzsJ9UylhLk7iFHmatBsgForchKxfapiLMFqcdkciS7wqU8RL5N2AYvnuSnBYv/3gvT7L
	b7LLsBGQfN0DTFaJR8rj4KJWHJLPCy57VjUfaYILQZXOt7Z+2zY/5VwqFRmLC76s380LPWs+
	bs1duWAJXgbDBR/V2mNtQmVgpvFMUC9LeuC+lhuHwrlB3cVwr3smyWwSm+I+8Ot7ZETft6XW
	qaNDXZ6xN4VpWETLY8V+3lAmF/8DuGw29PwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 15:18 +0100, Richard Weinberger wrote:
> On Thu, Nov 27, 2014 at 3:01 PM, Lukasz Pawelczyk
> <l.pawelczyk@samsung.com> wrote:
> > -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> > -   and is now available for re-use. */
> > +#define CLONE_NEWLSM           0x02000000      /* New LSM namespace */
> 
> FYI, CLONE_NEWCGROUP also claims last flag [1].

Yes, I'm perfectly aware of that. I've seen those patches.
This is RFC for now and CGROUP NS is not merged yet. I'll rebase when
time comes.

> As it looks we will get more and more namespaces, more than clone() can handle.
> 
> [1] https://lkml.org/lkml/2014/7/17/588
> 

-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



