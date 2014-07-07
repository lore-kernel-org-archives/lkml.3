Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaGGLoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:44:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGGLn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:43:59 -0400
Date: Mon, 7 Jul 2014 13:43:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf: Prevent race in PERF_SAMPLE_READ group format
 sample output
Message-ID: <20140707114346.GD19379@twins.programming.kicks-ass.net>
References: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
 <1403721875-15669-2-git-send-email-jolsa@kernel.org>
 <20140707090428.GG6758@twins.programming.kicks-ass.net>
 <20140707102020.GA22764@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VE1+SxTILTm8udN6"
Content-Disposition: inline
In-Reply-To: <20140707102020.GA22764@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VE1+SxTILTm8udN6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 12:20:20PM +0200, Jiri Olsa wrote:
> On Mon, Jul 07, 2014 at 11:04:28AM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 25, 2014 at 08:44:35PM +0200, Jiri Olsa wrote:
> > > From: Jiri Olsa <jolsa@redhat.com>
> > >=20
> > > While iterating siblings in perf_output_read_group we could
> > > race with addition and removal of sibling in perf_group_attach
> > > and perf_group_detach respective.
> >=20
> > So why would anybody do this?
>=20
> the test program from 0/1 email hangs up my server
> but no standard reason AFAICS
>=20
> I've got soft lockup, sometimes ended up with unkillable perf process
> also few total server hangs

OK, so that's useful information to have in a Changelog ;-)

Not immediately obvious how that can happen though. I can see the output
getting scrambled.



--VE1+SxTILTm8udN6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuofxAAoJEHZH4aRLwOS6qfQQAJxKVQWWxB0FUbrX4lkz+/WV
ROLhq/OY2SfXHYdcDaq0UTaKfjUj5NyI/nO8oo9z8euTPPteixjXO4YTLW41DWOj
eS8Sr754yPeLXRr6dv3yI495RhEQQhfDxLKdukHjWS+thb8kHl5N2ANAIJ/amW1z
nXczRD26rtIZzyjfUQwooTdviUydsQn10fXtM1xOvAnWfNxRBAugxV9L2R/pRhUW
M1vo2tTNKIcgbaHJYc6dS7O8YLo8dzrXbwbPSo9nMfZF05WCE3bXq0qll7Vh1sOR
zbRDt2KfPW3XWgrESa03IDbvC3mYc8ePJTFCxUoEvI9cUfqeQm/mnIwLiEySE7r+
ff8kVzWNaXqEBbwfHDW5iVqxvUNcMvHSnO1ATdHGCrSJZGpJVRBQBwxm2O4VfiAO
1Fr0prSt2tXw8fsY8ZOpubfAdgRpbCQON6dJKm/j8AGivjvvK9COomvl2y2vwnfo
5Rgzo7FA0+ARMuhcSGdRaqHDl0SVyO6Lmx5pCrw8cSyKTtcsQarxXZv5cKbeE5yR
qNHdxYiie/PGbJHGJv3kk8W1QZ/dyJmxzxCwgy24MnsUy8n+gZ57n+vpaj84/Ubz
Opw6PkCJOGbgqn3k6xrGzzEn1cWuCSccCaY0STKLzcZ50nCzRtG/NPjZH5XtbtFf
jiThf6FKg+RYofuGlYV7
=IG4k
-----END PGP SIGNATURE-----

--VE1+SxTILTm8udN6--
