Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaFDGtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:49:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaFDGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:49:10 -0400
Date: Wed, 4 Jun 2014 08:48:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140604064852.GE30445@twins.programming.kicks-ass.net>
References: <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
 <20140527142637.GB19143@laptop.programming.kicks-ass.net>
 <53875F09.3090607@linux.vnet.ibm.com>
 <538DB076.4090704@cn.fujitsu.com>
 <538E8462.80309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mVyWZAqmDBKO4Mga"
Content-Disposition: inline
In-Reply-To: <538E8462.80309@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mVyWZAqmDBKO4Mga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 10:28:50AM +0800, Lai Jiangshan wrote:
> On 06/03/2014 07:24 PM, Lai Jiangshan wrote:
> > Hi, Jason
> >=20
> > Could you test again after the following command has done.
> > (if Peter hasn't asked you test with this command before nor he doesn't=
 stop you now)=20
> >=20
> > echo NO_TTWU_QUEUE > /sys/kernel/debug/sched_features
>=20
>=20
> Off-topic!
>=20
> Why sched_features is in debugfs? I thought it is in procfs or sysfs.

because its for debugging, note that the entire thing relies on
CONFIG_SCHED_DEBUG, if you build without that its gone.

Its not an API its not for production use, its debugging.

--mVyWZAqmDBKO4Mga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjsFPAAoJEHZH4aRLwOS6wYQP/0fVJ9hb5SboMSTqQisdSnxp
+eepBS0QRmcdjeN3dIg9GmS6SfcJgDAgVmSVvZB9dLnt4InIsSTCMQEfo1I6uSHC
n5raMFHc7LO/HK2QRvJ0HsTL5QVcsYnKyxBzKiSyrJDG37xlolQcCaSZo7SncK7b
CgqzR0R1uobMOqKQjR9Ay4WvQBDwz0bV/djL+HtKvZilAH+opuRJR1PshL5vo/ZI
JtClWI9jJateT/D5zY/jNn5GJpDG90QMCCy89GdifTrhYQ6+Z3J2YsEYjlebdTym
AxxI7+prYJn+zcNIYM+RYiY77zDs5k53fljFZJQccwnTSCi4NfI4CBqSzIIU6tns
i8cxr8C3DPrIsNgzRcaPPiITmhzbQ4b4lkg+SnPt5PTluzyrswTXZe6stguldoV2
1H5CXE6rwLkifjweapKTCo9jdjftDoxcaTdGTXWul2UEkJobvhLIiYMicEcZ7jhc
0zu2VNotTFyAYnRDzfrpbQ6DV9Di0Z0NJzeOzMoyGk0S4WNlpm5F/K9RJ5yFkce+
aJ7RqfcpxMCZ9Jbz5qvEUrmQwt4Fn3mKOktYsK34cpq+jlU6NOPcH19CiwAKrxzT
FtaJOgUVmPfU10Ni+D7g4pQQ3ZoeAVth3XOXJPzjI7iURTovd1r6VgMo9E+WGbMi
kZJJrXPsuTBhMkCWnqWG
=Jv4E
-----END PGP SIGNATURE-----

--mVyWZAqmDBKO4Mga--
