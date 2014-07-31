Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaGaQag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:30:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:30:35 -0400
Date: Thu, 31 Jul 2014 18:30:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: josh@joshtriplett.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731163012.GA19379@twins.programming.kicks-ass.net>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <20140731161902.GA12697@cloud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzE1C30maAfuORZa"
Content-Disposition: inline
In-Reply-To: <20140731161902.GA12697@cloud>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzE1C30maAfuORZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 09:19:02AM -0700, josh@joshtriplett.org wrote:
> Also, ideally this should remain entirely optional; nothing in the core
> kernel should depend on it.

I suspect Steve wants it for ftrace :-)

--wzE1C30maAfuORZa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2m8UAAoJEHZH4aRLwOS6J5oP/0+ZSjk3hziSJk7KP/MlNxld
TSq+8iyk5Pgd4DnwAcYfGUE7D2Ldu7fG4V1ZRJuF3pj9S+pmernMa7udm/JQldrK
kQVurohTut3GdwiFWEfYkRXmNRckjhxzMIoScSNiROvqT0zZg5n6G54diFJ8hY+E
UpwjwubyTxgprC7rK2yHn760IObB6E95yOyvSoPid75i9wcO9Hz5904mOZwXz/Yz
zFl9Hog6Ex1SgGz2nricSpAXg6vED6dT77idELp6/T+NECaS3QSBBxp7RpPNPmHM
dcULpg0itKBuDru9qm8u048lu12v4L2I3ov4g2b+ipqGtmq2M12QT1CCcrVh2x3l
sJNVw+Hk3y5G9GYsNc8+3dPDbNNRptd5393oW4ENn/UX0pjGwVIIL3QOZ5zZ0FFk
mQgcanPWH9+OsOdlk+zSJbgA6tx4JS7ZgZAc1W0aX+As1+DP4fU4a6x5KnE89MOm
otKCH12a5RXkkDuPK9u+NGil+ee1UpqDyjhXWBFtSDRxCApSbQesFstCOM/qppBJ
/7YHSLv8MKHVe59+6GrMUXiCJIVkp/qxZ5RB861zj5jJrtq8mHT5lhMdTzCPJvlE
aiZXsAjNTlYniNe+2TEbeKbOYtoJa09EXoaK1rgPNWBvu2RYF8aviyuWRww3LsP8
Aq0HBVwWPuR5yadyss9S
=CHfA
-----END PGP SIGNATURE-----

--wzE1C30maAfuORZa--
