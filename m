Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaCMVPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:15:51 -0400
Received: from sauhun.de ([89.238.76.85]:34078 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbaCMVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:15:45 -0400
Date: Thu, 13 Mar 2014 22:15:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS [ver
 #2]
Message-ID: <20140313211539.GB2696@katana>
References: <20140306133559.29345.61422.stgit@warthog.procyon.org.uk>
 <20140306133606.29345.97103.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <20140306133606.29345.97103.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 01:36:06PM +0000, David Howells wrote:
> The SMBUS tracepoints can be enabled thusly:
>=20
> 	echo 1 >/sys/kernel/debug/tracing/events/i2c/enable
>=20
> and will dump messages that can be viewed in /sys/kernel/debug/tracing/tr=
ace
> that look like:
>=20
>          ... smbus_read: i2c-0 a=3D051 f=3D0000 c=3Dfa BYTE_DATA
>          ... smbus_reply: i2c-0 a=3D051 f=3D0000 c=3Dfa BYTE_DATA l=3D1 [=
39]
>          ... smbus_result: i2c-0 a=3D051 f=3D0000 c=3Dfa BYTE_DATA rd res=
=3D0
>=20
> formatted as:
>=20
> 	i2c-<adapter-nr>
> 	a=3D<addr>
> 	f=3D<flags>
> 	c=3D<command>
> 	<protocol-name>
> 	<rd|wr>
> 	res=3D<result>
> 	l=3D<data-len>
> 	[<data-block>]
>=20
>=20
> The adapters to be traced can be selected by something like:
>=20
> 	echo adapter_nr=3D=3D1 >/sys/kernel/debug/tracing/events/i2c/filter
>=20
> Note that this shares the same filter and enablement as i2c.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Applied to for-next, thanks!


--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTIh/7AAoJEBQN5MwUoCm2UD0QAKctRYUHobrs+tz/46xRLziP
s51XmvZMT53z/dQdGcw5HakxnR9p1k7sIywAW8xyC0IQyH2W8gThsiLlQ3DwBY/N
JaPLFSHxa8eQaRA2bIDvShfPA4TJrUYeFHcok7e++p9ljaaA59BJhTY8epFVjok1
AMQz1QXOexH0aBC3qBL+mUF0ZBKtMblkBaGc2Qg/ge1a9sx5agmthUIH8q0YpuG+
hrfaXSmV4nFmOFn1Umj0DJ2qFxULSLkvQJCf6TYi/w2aJ++QEK3nqvcP2MEcJ2V6
5hpTJizjAjYOA36rk1fjIhkAN/IxLkZYqWXRjuFlqE2uWus61lMmS9OO20GR1utb
W3BoGubbjWA2CeLjrYViHq9M8dYGESifnL6ktUEYHrVt7/MVBvUz7M5rHyO38WwP
hKAXYSbUY5d7nZkCY2FrdcaZoPKQHBsQGWJCsMdJSGYTuOI6d1KTbzfYPhU+6Me8
0SwJTvwBlBBpm0x9Ph5GANKuZl5yd4nWy5PqUFQ5US5SWSN3vcYUannbp8OoUyVK
21Rw/J30mGOn0tiJxKt44bzrXtYOeexO5k/s7UOl1edxEYGPush6ZDopWQSVtA4t
ZS7ytsYj2sUfSY+iZSuXShP+tq8HwypbiNonm65e6TWrjNzJODMj5w+8YMLE2zLu
Ub0hFX3NmngT8PM9Knpu
=BlAA
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
