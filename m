Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaAMPra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaAMPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:47:27 -0500
Date: Mon, 13 Jan 2014 16:47:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fget*() cleanups
Message-ID: <20140113154748.GA6496@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com> <20140110153459.GA31491@redhat.com> <20140111063438.GY10038@linux.vnet.ibm.com> <20140111181908.GA7358@redhat.com> <20140111222737.GE10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111222737.GE10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Paul E. McKenney wrote:
>
> On Sat, Jan 11, 2014 at 07:19:08PM +0100, Oleg Nesterov wrote:
> >
> > It seems that you misunderstood me, let me send v2 for review.
>
> Ah, I did misunderstand you.  For both:
>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks!

While at it, can't we factor out the code in fget*() ?

Probably I dislike the code duplications too much, but imho fget*()
abuse the copy-and-paste.

On top of this series, saves 600 bytes.

Oleg.

 fs/file.c |   70 ++++++++++++++++--------------------------------------------
 1 files changed, 19 insertions(+), 51 deletions(-)

