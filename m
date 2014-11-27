Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaK0OoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:44:25 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19322 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaK0OoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:44:20 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-86-547738c1b676
Message-id: <1417099455.1805.17.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Richard Weinberger <richard@nod.at>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
Date: Thu, 27 Nov 2014 15:44:15 +0100
In-reply-to: <54773757.8090905@nod.at>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xK7oHLcpDDBZNl7GYs34Nm8Wb69OZ
	Le5t+8VmsWbZSzaLgx/us1i8a/rNYvF/Wwu7xf/XOhZ9j4MsTmy+z2jxc+UuRosz3bkWm793
	sFlc3jWHzeJDzyM2izlv37JZXJ2+nt3i0oEFTBaXft9ltlj5+TaLxdb9rYwWx3sPMFl8vvaL
	3eL63S3MFh8mbmCzmLzzDaNF25KNTBbnGp+zWJy/cI7d4vLWmcwW5/8eZ3WQ95jV0MvmMbvh
	IovHzll32T0WbCr1uLY70mPzCi2PxXteMnmcmPGbxaNt+T4Wj8k3ljN63JxX6PHx6S0Wj5Pz
	frJ5vN93lc3j6P5FbB53r79kChCJ4rJJSc3JLEst0rdL4Mp4fvQea8EX9oqZryMaGPvZuhg5
	OSQETCQm9b9ngrDFJC7cWw8U5+IQEljKKNH86jAThPOfUeLe3JUsIFW8AkYSF9/0gdnCAuoS
	h+f/Zgex2QQMJL5f2MsMYosAxd+9nAo2iVngEqfEt/6FYA0sAqoSc7pOsoLYnAJqEusmPmKG
	2NDPJLHr1lSwBDNQ96R5i5ghbtKSeN/1E2qzoMSPyfdYIGrkJTavecs8gVFgFpKWWUjKZiEp
	W8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJHV83cG49JjVIUYBDkYlHl6GW2UhQqyJ
	ZcWVuYcYJTiYlUR4OQzLQ4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwphvmrtKq3/HyvEFa1Q8O
	/piTV30vHL16rv/S69lCp9fJXL71/UvV5+hbcrMLGH0MxP0Xv9fuEDLa92XS5o+mV+0ka8v5
	r04Oqfyn9ulOndHyLev0WvdXfc5+a1QYefj09Dv3PWo3/uoTlDu14i2Hx2Tv1hrZA17Xyj17
	DXKe3/s9aW7c3tneq5VYijMSDbWYi4oTAWi7yNb7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 15:38 +0100, Richard Weinberger wrote:
> Am 27.11.2014 um 15:35 schrieb Lukasz Pawelczyk:
> > On czw, 2014-11-27 at 15:18 +0100, Richard Weinberger wrote:
> >> On Thu, Nov 27, 2014 at 3:01 PM, Lukasz Pawelczyk
> >> <l.pawelczyk@samsung.com> wrote:
> >>> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> >>> -   and is now available for re-use. */
> >>> +#define CLONE_NEWLSM           0x02000000      /* New LSM namespace */
> >>
> >> FYI, CLONE_NEWCGROUP also claims last flag [1].
> > 
> > Yes, I'm perfectly aware of that. I've seen those patches.
> > This is RFC for now and CGROUP NS is not merged yet. I'll rebase when
> > time comes.
> 
> Just wanted to indicate that we run out of constants. :)

True, the last one is 0x80000000. I did not notice that. Thanks for
pointing out.

Any suggestion on what can be done here? New syscal with flags2?


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



