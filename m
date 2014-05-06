Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaEFLnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:43:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:60407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaEFLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:43:20 -0400
Date: Tue, 6 May 2014 13:43:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
Message-ID: <20140506114315.GG11096@twins.programming.kicks-ass.net>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
 <20140429145221.GH2639@e103034-lin>
 <5360C15B.9060608@linaro.org>
 <53689E62.9090403@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ugCSa1rMkiCAmd9S"
Content-Disposition: inline
In-Reply-To: <53689E62.9090403@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ugCSa1rMkiCAmd9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 04:33:38PM +0800, Alex Shi wrote:
>=20
> >=20
> > Maybe the predication is reasonable on per task history. but on a cpu
> > load history, with many tasks rebalance. No testing show current method
> > is helpful.
> >=20
> > For task load change, scheduler has no idea for its future except guess
> > from its history. but for cpu load change, scheduler know this from task
> > wakeup and balance, which both under control and its aim.
> >=20
> >=20
> > I think the first patch of this serial has the same effect of LB_LIAS
> > disable. and previous result show performance is good.
> >=20
> > Anyway, I just pushed the following patch to github, maybe fengguang's
> > testing system will care this.
>=20
> Fengguang,
>=20
> Are there any performance change on
> https://github.com/alexshi/power-scheduling.git noload repository?

You forgot to qualify that with the important bit; on _large_ systems.
Esp. non fully connected numa boxen. Also, I'm not sure Wu has workloads
that are typical of such systems -- even if he has such machines, which
I don't know either.

Enterprise distro testing has _some_ of that, but the very sad truth is
that most enterprise users lag behind at least a full release cycle. So
by the time people start using the kernel, its so old nobody really
cares anymore :-(



--ugCSa1rMkiCAmd9S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaMrTAAoJEHZH4aRLwOS6dtkQAJcSaP54jjn2WMTa+PAFJROn
ktjNsDY+Bikr2JDJaPr7LzFb8QQ/MQS7sNOn+d9G47OQ7jJuJY5wCKzNfyJtUz8G
KWdm+UbqlfeFjXL1uSCFXXan5BWlWkml1dDVv8FBgG4p7ds0Ism2Excz+aDhNfET
rJ1dB6flTuhk5ssJ29zJRYmI3tmgqU0cJqgzPhp7r+etiy+Q9YSuGVzDGB6p7D49
Ro4gCs2NEVaxAJAx1743jKHmCnJzs7LUGN/xvgUZcS+hcF2tg5fhQH0aoNqyS8zF
mzlGLbKckQo4mx7t3tliC83Cq31//5KQqoLv/hhiP442MdcRKA0LPpbaMyr0jNhk
9UBqFlFIHbrCE13FNXgGasH6XKVMYZo+G7MugiW3AqeWWkGFDp3szGxX69zMw75x
Zpsf58tQwp9b6H+T0JqCCAu2DCNfmYNtMH1ZZXnPh+u9hJ2iQeVw0As2C+AL3qme
hZbGmrGlgOruSWwKmPE46YqUfa5lbUHzAsNkaZJyDJxlKynHukxs3Rggrp8w1AAF
Gazf0KcOOzVLKruvC3SNdRDPbeQUV9z2aaGtBAC6pTsl+NRC61Jfnr4VBnbrp1Zk
IrvhE85vDl3CMtljXpNfJiTANXIB5GyJH5bvsEEkXYtoBv3rtHqqM83auBa72fCi
w99+4mE6/edA2zHCx67D
=GhrS
-----END PGP SIGNATURE-----

--ugCSa1rMkiCAmd9S--
