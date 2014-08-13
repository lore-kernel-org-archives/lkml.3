Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaHMJyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:54:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMJyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:54:19 -0400
Date: Wed, 13 Aug 2014 11:54:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
Message-ID: <20140813095402.GH9918@twins.programming.kicks-ass.net>
References: <20140812153812.2923046a@monolith.infinux.org>
 <yw1xr40l2whi.fsf@unicorn.mansr.com>
 <20140813082756.GB2923@twins.programming.kicks-ass.net>
 <2838655.H5W5zNkR37@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dJMCvz8ywNNMqcIT"
Content-Disposition: inline
In-Reply-To: <2838655.H5W5zNkR37@merkaba>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dJMCvz8ywNNMqcIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 11:37:28AM +0200, Martin Steigerwald wrote:
>=20
> Also I think:
>=20
> martin@merkaba:~> ls -l /sbin/init
> -rwxr-xr-x 1 root root 40648 Aug  3 21:01 /sbin/init
> martin@merkaba:~> ls -l /bin/systemd
> lrwxrwxrwx 1 root root 20 Aug  6 13:41 /bin/systemd -> /lib/systemd/syste=
md
> martin@merkaba:~> ls -l /lib/systemd/systemd
> -rwxr-xr-x 1 root root 1084816 Aug  6 13:42 /lib/systemd/systemd
>=20
> martin@merkaba:~> apt list 2>&1 | egrep "(^systemd/|sysvinit-core)"
> systemd/unstable,now 208-7 amd64 [installed]
> sysvinit-core/unstable,now 2.88dsf-53.3 amd64 [installed,automatic]
>=20
> is highly worrying. A one MiB binary as PID 1? Really?

Yeah, utterly insane. PID 1 should not be doing these things; no single
process should do as much as systemd does, PID 1 least of all.

--dJMCvz8ywNNMqcIT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6zW6AAoJEHZH4aRLwOS6JcwP/0xJAMXHHT49quzhc4xoi1WR
smKD9yBZkQSUr0JFuhifYzpZB/wQf3VE3JjjOgNLVxSYX2IyzP9GGUfhQt2yvC0u
EVMgF8Y2D6ICCXsicLer/QGlzMzULr4KeldhuhOYvmeMfqSW+6R4ZAxetsRE0Gmy
K1+O6rbbE7/j7AiDCAL4QommdRCr/+SZf4Mr1dx/ZcTo1NvPXe5nic1BVrnH1Q9R
GdMWK3X3RYVgkIqnuYm4sK6yqpk2snHmMVRY4d5AeomeaOM7Z7XtCjLsCqYzPM9R
aOy17aSgQy5MJdxT4G21tVkZOtxCg9H1tW3L+1tVk7VRUZd0t9O2uutD17drVc+3
KdoaXtFgbJdf38NoVsvvYxAZ+o+ppuKS/yXCMZGGkTlLzYGMBHwD53CHHIjoXU2B
6c0/wtppe3xZvhFTmI22zsd3Vj//WIRU5CDiHI59eCtUg2LG3s7xhKESg9yw6LbP
MZQ0gYX3zlq0GydHsxqwpNh1wRt+8OO4K0u0sls+uyB30yF6pjlYIlGqMX8iKbO9
rrjSGNV3F5YIM7Lpe/4CprQ0FPhHPhr4DLJ6imJ2u9vi04yHFdetOIHfXFgAWmvL
Q24YNvs6g+Q+diy13mawvYq+PihRnY2JwroGMN/2/FDwjUDFnoXgnltjPuXQ+BGG
2lva9osfxbGhtvn3FesR
=KjrH
-----END PGP SIGNATURE-----

--dJMCvz8ywNNMqcIT--
