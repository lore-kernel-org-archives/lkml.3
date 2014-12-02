Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaLBMnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:43:21 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59253 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLBMnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:43:19 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-14-547db3e35149
Message-id: <1417524193.1899.2.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Lukasz Pawelczyk <havner@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Richard Weinberger <richard@nod.at>,
        Daeseok Youn <daeseok.youn@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Rientjes <rientjes@google.com>,
        Alex Thorlton <athorlton@sgi.com>, Juri Lelli <juri.lelli@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Dario Faggioli <raistlin@linux.it>, Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Moore <pmoore@redhat.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 02 Dec 2014 13:43:13 +0100
In-reply-to: <1417109911.1805.27.camel@samsung.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
 <1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
 <1417101060.1805.21.camel@samsung.com> <87d288zm3a.fsf@x220.int.ebiederm.org>
 <1417104439.1805.25.camel@samsung.com> <871tooy4nc.fsf@x220.int.ebiederm.org>
 <1417109911.1805.27.camel@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xa7qPN9eGGEy4IGAxZ/0aNos316cz
	W9zb9ovNYs2yl2wWBz/cZ7F41/SbxeL/thZ2i/+vdSz6HgdZnNh8n9Hi58pdjBZnunMtNn/v
	YLO4vGsOm8WHnkdsFnPevmWzuDp9PbvFpQMLmCwu/b7LbLHy820Wi637WxktPl/7xW5x/e4W
	ZovJO98wWrQt2chkcXnrTGaL83+PszpIe8xuuMjisXPWXXaPBZtKPRbvecnkcWLGbxaPtuX7
	WDwm31jO6HFzXqHHx6e3WDxOzvvJ5vF+31U2j6P7F7F53L0OVHtmwRF2j8+b5DymHGpnCRCM
	4rJJSc3JLEst0rdL4Mr437SdveAjS8WBnc/ZGhhfM3cxcnJICJhI/Nr5CcoWk7hwbz1bFyMX
	h5DAUkaJ23dus0A4/xklfh/ZygZSxStgKPF62UQWEFtYQF3i8Pzf7CA2m4CBxPcLe8EmiQjo
	S9x8PwlsErPATA6Jh/cPgDWzCKhKTNsyCayZU8BY4uiz5+wQG2azSMzccJ8JJMEMNHXSvEVQ
	N2lJvO/6yQKxWVDix+R7LBA18hKb17xlnsAoMAtJyywkZbOQlC1gZF7FKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJEZIWvuxgXHzM6hCjAAejEg/vifM1IUKsiWXFlbmHGCU4mJVEeH8Z14YI
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYDTXnvuJ4d31xc0aUnm3uRcLtl+Zw+eqmbvhfWN/g/Kf
	dx3fNx7Mfpu4VvOwku/G+TLzjmz9tntWz0MVxWN++6Oq7/k7zNBTXJx5qfUaL6/ut5s26jvc
	ln8+Ueh/g31jRMvnLdyhiQxXEwrEr2uLvX/soKK1qvfM84X1c5qlT3dqC0e5bW0uiFZiKc5I
	NNRiLipOBABfiMFC6QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 18:38 +0100, Lukasz Pawelczyk wrote:
> Right now the major issue I see is that LSM by itself is not defined how
> it's going to behave. It's up to a specific LSM module.
> 
> E.g. within the Smack namespace filling the map is a privileged
> operation. So by tying them up you cripple the ability to create a fully
> working user namespace as an unprivileged process.

Entertaining the idea that LSM namespace would be tied to user namespace
(as you suggested) how do you see the limitation I described above?


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



