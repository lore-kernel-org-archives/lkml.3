Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaHHQxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:53:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:52587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaHHQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:53:04 -0400
Date: Fri, 8 Aug 2014 18:52:51 +0200
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
Message-ID: <20140808165251.GJ9918@twins.programming.kicks-ass.net>
References: <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808151643.GD9918@twins.programming.kicks-ass.net>
 <20140808113949.046522c5@gandalf.local.home>
 <20140808161709.GF9918@twins.programming.kicks-ass.net>
 <20140808124018.46724b50@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7T7KKykdtTJNweTu"
Content-Disposition: inline
In-Reply-To: <20140808124018.46724b50@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7T7KKykdtTJNweTu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 12:40:18PM -0400, Steven Rostedt wrote:
> On Fri, 8 Aug 2014 18:17:09 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Fri, Aug 08, 2014 at 11:39:49AM -0400, Steven Rostedt wrote:
> > > Also, anyone can register a function handler (perf, systemtap, and ev=
en
> > > LTTng can).
> >=20
> > So how common is it to have more than 1 function event handler, and how
> > many of those cases is there significant difference in the actual
> > functions?
>=20
> For me, it's quite common. Of course, I tend to poweruse function
> tracing :-).  I do make instances and trace a few functions here and
> there, while tracing all functions.

Meh, then you have multiple trace files to combine, which makes the
entire reading/scripting thing just _that_ much harder.

Not useful.

--7T7KKykdtTJNweTu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5QBjAAoJEHZH4aRLwOS6tRMP/i7AG66/QIG8wbqXVduqxCCb
X2w43Z4fC+ORhXZmDTSyUAaOq/t4u93z2LL8Utu8bRktrzFIEZ6tdUrIM2cc0lRe
4m7Piy6OEBmmdUM+2N9xRojwK62eQjf3Q/ypFjEVq+pSCikHmgNg7Vtv0luBYa4S
bVlw0AtZa3YVviPaHfmAswUSPI86rjP032/4whLQtuvYhLKH8dsrcF7/d66baeiD
oSlZlC11LZpRkWaA0K0ugyD+8KCRrjLgi76vIqEQSl/xKxJUgcnrdzx4OL1sCPu8
5HkZJSoLQUkGsqaEmmRk1sZXNFKcV4/wQQTCu5PEOz0M4fiy1mIOVYh/XqywsiLv
O/BCqweNOMd2OWPeE+RZLDffFSFq+1mNhoIu5b6sUFtotptblZJITLOjkQ+L8VNy
GbMi5EEGDMg6h9SAaFwd9Ob8xj8NdVRD2qG+bEmtfefKETYv8hpKaL6XeNVRQN0f
PceMVM2big5v98iL6VKOgJPpZKuU8gvrtHOCec8CAVl6U3Rh0pz39HfXiPFy2PCw
yhU4Bj55LwuivXRzxAAgYMA0QjssnhtxbxZyaWSOzD7TRcSTraKLvfASi5u1M9B1
cS4D2a6bELSVr4nYEoj6bQJH29aO3DleajicVmqg41Rd5DnBTFl80rqGQOtqVzn3
vMYCK58pHcurDYqm+9cn
=SS58
-----END PGP SIGNATURE-----

--7T7KKykdtTJNweTu--
