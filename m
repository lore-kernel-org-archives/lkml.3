Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936296AbaFJHht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:37:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:47692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274AbaFJHht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:37:49 -0400
Date: Tue, 10 Jun 2014 09:37:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 15/15] perf tools: Support spark lines in perf stat
Message-ID: <20140610073744.GU3213@twins.programming.kicks-ass.net>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
 <1402344150-14860-16-git-send-email-jolsa@kernel.org>
 <20140610050443.GA14522@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0+HW0pjZ+2jqF7e"
Content-Disposition: inline
In-Reply-To: <20140610050443.GA14522@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0+HW0pjZ+2jqF7e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 07:04:43AM +0200, Ingo Molnar wrote:
> > Example output (view in non-proportial font):
> >=20
> >  Performance counter stats for 'true' (10 runs):
> >=20
> >           0.175672      task-clock (msec)         #    0.555 CPUs utili=
zed            ( +-  1.77% ) =E2=96=88=E2=96=84=E2=96=81=E2=96=81=E2=96=81=
=E2=96=81=E2=96=81=E2=96=81..
> >                  0      context-switches          #    0.000 K/sec
> >                  0      cpu-migrations            #    0.000 K/sec
> >                114      page-faults               #    0.647 M/sec     =
               ( +-  0.14% ) =E2=96=81=E2=96=88=E2=96=81=E2=96=81=E2=96=88=
=E2=96=88=E2=96=88=E2=96=88..
> >            520,798      cycles                    #    2.965 GHz       =
               ( +-  1.75% ) =E2=96=88=E2=96=84=E2=96=81=E2=96=81=E2=96=81=
=E2=96=81=E2=96=81=E2=96=81..
> >            433,525      instructions              #    0.83  insns per =
cycle          ( +-  0.28% ) =E2=96=85=E2=96=87=E2=96=85=E2=96=84=E2=96=87=
=E2=96=88=E2=96=81=E2=96=86..
> >             83,012      branches                  #  472.537 M/sec     =
               ( +-  0.31% ) =E2=96=85=E2=96=87=E2=96=86=E2=96=84=E2=96=87=
=E2=96=88=E2=96=81=E2=96=86..
> >              3,157      branch-misses             #    3.80% of all bra=
nches          ( +-  2.55% ) =E2=96=87=E2=96=88=E2=96=83=E2=96=85=E2=96=81=
=E2=96=83=E2=96=81=E2=96=82..
> >=20
> >        0.000316660 seconds time elapsed                                =
          ( +-  1.78% ) =E2=96=88=E2=96=85=E2=96=81=E2=96=81=E2=96=81=E2=96=
=81=E2=96=81=E2=96=81..
>=20
> The noise data is not aligned vertically in the changelog - is it in=20
> the real code? It should be.

I still dislike those spark lines, I still think they should plot the
distribution and not just the first 8 or so values.

--B0+HW0pjZ+2jqF7e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlrXIAAoJEHZH4aRLwOS6TCsP/Ri8jqTfT3+N8NW8nlH05Ery
LZMFFnCZvyMq0ShEbg1Txmh0b4UUCLNoWOVkYPto1cl2GmjNWApK9xCj65NOfdSw
3s1JnXSfk0pynSnxDxZzLkwvszMeyJ6cI81srttVQ124btiyYiS0RbdimgJ11h3Y
ruTxvSbBCIfIS+UOwjuYQAmltFK2FcLgHix0YUe1fD/yZZKJJ1V/1U3WrGiTmY93
RywMH3Yd/fA74qvQcl/+9EkcSzAyXMxfansY0fgJkHZvTID8Grk1xtF7HARvdP9F
mQ21mfpEGUXgtESfOYfFiFfh+09IGTTLYTh41W1AqvnE1V35TnDKQhSrxItclcFw
B5ysFC1CubExaOOMsG5V4v3wioGbxr/f84VcViChxy26dLMUnXskuPDjEmyhR6Qs
JBlcgySvS6dU2//NvyIT82pfzxX8QRQ9mFOwZ6nUXj0evInDIKzqjiWX/RfaDrpM
7tYy+WEC9R2Ozy2XL+icym4AZATYPOH65MSkl8rtewCCS930N8oPLm5nIpRPCyTE
MaFYmBr8MW9f1kcqLbck5FjDCSkbzjjLGlgNrfZU9RuoWc1XsGOeLPqwFTlI/aD/
y5/lv9W5nV7v+/aCupTSdPK8H6wnUc4mmNAAEtRzFIImIcdRJ5IEp5Gpxfj0tNWh
J6Fl1qv27BNYjNRSuwHH
=Kiy3
-----END PGP SIGNATURE-----

--B0+HW0pjZ+2jqF7e--
