Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaHHQR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:17:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:52452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbaHHQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:17:26 -0400
Date: Fri, 8 Aug 2014 18:17:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808161709.GF9918@twins.programming.kicks-ass.net>
References: <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808151643.GD9918@twins.programming.kicks-ass.net>
 <20140808113949.046522c5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RSgmI+M79eD5fHET"
Content-Disposition: inline
In-Reply-To: <20140808113949.046522c5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RSgmI+M79eD5fHET
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 08, 2014 at 11:39:49AM -0400, Steven Rostedt wrote:
> Also, anyone can register a function handler (perf, systemtap, and even
> LTTng can).

So how common is it to have more than 1 function event handler, and how
many of those cases is there significant difference in the actual
functions?

Because that's the case you're optimizing for. Why is that an important
enough case.

I'm thinking I'll never trigger that, I only ever have the one normal
ftrace handler. So no trampolines for me, the code you have now works
just fine.



--RSgmI+M79eD5fHET
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5PgFAAoJEHZH4aRLwOS6eigQAJHmrBnma4IduCE1GUsVitEg
yikz+Ycc9Km5LzBETL1OBI+uZXxyUYedyI9K970NUIgdnWc0PRlnyX75qOSno9hf
YUjsNiLQSDIypvDM145HISMrKn9uIhsJhh29FsThOJXZo4ABF6NC8tUymV1SthkB
FeIHBg8PQqV2+O9CwI/FuVH/l3jKht46SEvM4Izul50wdl6G46q3WKNGHzHXY24R
Fsa0iJcqfFyZabVD7nVT2Djoy/UPulAUlsiOqAsKFXkfDTg/vR24D72cpbRtiCY9
PJJMJNBTkCISc0/xFp57MdNc90DhFbhxlCsHrDnBnIDoc4X+eu0TlbYLLDhmGU3S
oQRVU7O5RyvUd22DCNxd5Z4QtzcewkqfP44K04GomiE9SM00LmOmXOHQgKWQS+Nw
oJvxxarrh1T95azm6ceIzFn9l7bKf/7bc3ribcX4Zgt6jg+8PBdu8sE+W83mP+tG
QhHd0k6LPMtwWyZXFa/D8vfdfvpOlQe980aL2JiuXs+oAKS6N7mfMC9kJOo1rXo5
+WtoLafxguvPkIgIhFNx+f2q+1Zh9y88qLYeDnSFJlsk5gYiHJUMYSYDqSLViKVR
fF1gdXLFALIX5D6SnCsABfR9WFpiiLo09p4fnkKVeJb8V27KRTk3Jk/g69Gs3LsF
CBNNsdKzsg23Dr1+pB8p
=IORY
-----END PGP SIGNATURE-----

--RSgmI+M79eD5fHET--
