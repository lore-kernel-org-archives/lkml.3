Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaFCFVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:21:38 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:37439 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751740AbaFCFVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:21:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:
X-HE-Tag: body21_81ea0b024fd58
X-Filterd-Recvd-Size: 2902
Message-ID: <1401772891.13101.5.camel@joe-AO725>
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 22:21:31 -0700
In-Reply-To: <20140603051026.GA24869@thin>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
	 <1401741411.7323.36.camel@joe-AO725> <538CE0E0.8020002@infradead.org>
	 <20140603000246.GC14801@cloud> <538D1FC6.3090500@infradead.org>
	 <20140603015133.GA20354@thin> <1401765096.7323.61.camel@joe-AO725>
	 <20140603051026.GA24869@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 22:10 -0700, Josh Triplett wrote:
> On Mon, Jun 02, 2014 at 08:11:36PM -0700, Joe Perches wrote:
[]
> "the appropriate mailing lists" often just mean LKML,
> for many patches I've sent; almost nobody sees a patch only sent to
> LKML, unless they specifically go looking for it.)

It's a good thing then that Andre Morton is all-seeing.

> > the
> > quantity of names and addresses on the [0/n]
> > patch can easily exceed vger's 1024 byte
> > maximum header size limit.
> 
> Is that the limit on the size of any *one* header, or on the size of all
> headers combined?

All headers

> > Another possibility is to add a new "--bcc_cmd"
> > to git send-email so that vger's header limit
> > can be worked around.
> 
> That breaks the ability for the recipients to see replies.

<shrug>  If interested, the recipient knows where to look.

> > I had patches to git to do that awhile ago.
> 
> That'd be handy; did you try submitting them upstream?  What reception
> did you get?

I don't recall.
It was a bit after I added the cc-cmd stuff.
Nearly 7 years ago now.

> If you have objections to putting it directly in get_maintainer.pl,

I do.

> it'd
> be easy enough to make a secondary script (patch_add_maintainers?) to
> drive it.

Go for it.

cheers, Joe

