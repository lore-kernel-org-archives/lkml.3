Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaCPXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 19:16:28 -0400
Received: from ozlabs.org ([203.10.76.45]:56687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbaCPXQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 19:16:23 -0400
Date: Mon, 17 Mar 2014 10:16:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20140317101621.92f0d6d9bab79a0ea24fe37b@canb.auug.org.au>
In-Reply-To: <20140315052942.GA30262@kroah.com>
References: <1394596541.4840.70.camel@pasglop>
	<20140312113742.GM28112@sirena.org.uk>
	<1394654396.4840.94.camel@pasglop>
	<20140312200232.GA22332@htj.dyndns.org>
	<1394655292.4840.97.camel@pasglop>
	<20140312202102.GB22332@htj.dyndns.org>
	<1394671056.4840.103.camel@pasglop>
	<1394748895.15098.16.camel@pasglop>
	<20140315000343.GD5687@kroah.com>
	<1394852249.15098.75.camel@pasglop>
	<20140315052942.GA30262@kroah.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_10_16_21_+1100_=TjaJ_ofyhNHOrQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_10_16_21_+1100_=TjaJ_ofyhNHOrQM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sat, 15 Mar 2014 05:29:42 +0000 Greg KH <greg@kroah.com> wrote:
>
> On Sat, Mar 15, 2014 at 01:57:29PM +1100, Benjamin Herrenschmidt wrote:
> >=20
> > It's messy. Stephen really doesn't like if we pull each other trees like
> > that unless they are topic branches. He also doesn't like when we keep
> > pulling Linus in.
>=20
> I only pull Linus in after a -rc in which I have merged patches with him
> for that "topic".  Otherwise I end up with merge issues, and for testing
> reasons, I want those fixes from Linus and from me, in order to keep
> people from hitting the same already-fixes issues.

Maybe you should consider instead just merging the branch you asked
Linus' to merge instead of back merging his whole -rc ... especially when
the merge commit message is usually just something like "We want those
fixes here for testing and development" which doesn't actually tell us
anything very useful.

Your trees always have lots of back merges of Linus' tree in them and I
don't know why Linus has not complained about it before now (or at least
explained to you why we normally don't do that).

> Just take my tree, it's not a big deal,

Except, of course, you are completely discounting any testing that Ben
has done on his tree that could be invalidated and/or complicated by
pulling in so much more of Linus' tree at this point of the cycle.  And
it complicates the git history even more than just your trees already do.

/me is a bit cross after such a nice holiday in HobbitLand and may need
to take deep breath :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_10_16_21_+1100_=TjaJ_ofyhNHOrQM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJjDFAAoJEMDTa8Ir7ZwVidAP/0/Ym5mc3CAZjH9lalRQbAaa
bN8MvrU0sNOM1lltkojPNDpXZ9CEsNlo7VfzIqzMrlI517TVCHGo+HXHoprUMKqp
hBUyb5uUii+lgkTPnIvI2AgoUuCj0Tb+65ZarVWTap5X+OtGnubPAnNVnRqmw3Z7
tIeID83stDr4rzoLOg9Cmk+3RFpKEWYzb7WRZKlwMly9YIa4Co5wMXic0SVzABJb
peZlNGQjh5vIv/9UjHkYYKWbfyUB4u87LIlsFfomhRgBtkdQFEWDFNbbHpF7dTEG
o0o1T/8SGaO5n5jJIiuHMjcZfI7uXt+hZyvAuGeNoZMVUUwSjW1w200jEnEX/d15
GQ4cGIlM6zeChziiwZQmCOa1oojXdaceeAJKjW91NAzJSnAmpIcPjoc7Ldm8kfTi
EdGWN88sld85V8urTBGhKNGhe/yR1MFQQFh3GYnc0/ktiw5OP27oJ22//rqsi0XK
ojmVsxQMhJ7XXFRNjKyLqjis6jzjgQ8lk/YFz9phQOnz5eWXR0VVikxcyIIqKYpf
QovFlTVxSLqDMC+LIju3IsqveIjdPetRAYdO4b0M7E6A1mfwwZXEB5xqFY6E5gFO
X3USc8hzHmMxlO9CJtUdFZWe0GBBoVsfTKnsbjpwXdTjZfVnu0GwTnkSdJVwhFjE
CIWutdy5k1ne+puxvh0g
=Q2+q
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_10_16_21_+1100_=TjaJ_ofyhNHOrQM--
