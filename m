Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaELIsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:48:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaELIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:48:38 -0400
Date: Mon, 12 May 2014 10:48:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kaixu xia <xiakaixu1987@gmail.com>
Cc: xiakaixu <xiakaixu@huawei.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung@kernel.org>, Huxinwei <huxinwei@huawei.com>,
        peifeiyue@huawei.com, fweisbec@gmail.com
Subject: Re: Does perf support different length of user-space hw_breakpoint?
Message-ID: <20140512084823.GO30445@twins.programming.kicks-ass.net>
References: <53707DD6.2000108@huawei.com>
 <20140512080503.GL30445@twins.programming.kicks-ass.net>
 <CAGjdHukwC3cu3YOSSteXsC4_52m-YTdAAYCfXV+q5A2pnW+CKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RTD9Hr/VfB+mRRII"
Content-Disposition: inline
In-Reply-To: <CAGjdHukwC3cu3YOSSteXsC4_52m-YTdAAYCfXV+q5A2pnW+CKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RTD9Hr/VfB+mRRII
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 04:20:44PM +0800, kaixu xia wrote:
> 2014-05-12 16:05 GMT+08:00 Peter Zijlstra <peterz@infradead.org>:
>=20
> > On Mon, May 12, 2014 at 03:52:54PM +0800, xiakaixu wrote:
> > > Hi guys,
> > >
> > > Does perf support different length of user-space hw_breakpoint,
> > > such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
> > > HW_BREAKPOINT_LEN_8?
> > >
> > > Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
> > > by default from the source code and simple test.
> > >
> > > May I have your opinions if I want to trace different bytes of
> > > hw_breakpoint addr?
> >
> > Frederic?
> >
>=20
> Sorry, can not fully understand it. Can you give more details on that?

I asked Frederic to answer your question :-)

--RTD9Hr/VfB+mRRII
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcIrXAAoJEHZH4aRLwOS6/zMQALVehCXX4rb95WDOTsfG4oCX
PkA4ZtJDPjEvyUx160UN+yDq4DWgYUVndWqwyolY+7v0XAvnUm9hLPFmYfU5w9XV
a/RNEaRtZzSPHe4VYeSXtGNSpN3mBdL07H/uR/xb1BnNqPG5DeKT28p8w8iyg8i8
Nxpmp4YlxrcoOrYO9P/lRNvC7cVOZEKDzJGElRtWv5rYiOzaeX9bdEN7aB0wePxb
oFQqQ7fbod+HGYUaBnck667ruNwmvofkdG3ccSj0U/cb+4rdxDZqi6JgtXb5No3A
vOMpLEV1ZUd0wKiCR4npZ6bJj2MY/fkIUdW7U1MtEjUiEmXHkMs+BUx8rEFovVHS
1rOouIdFs/L4zQ7nEXLK0BV1qcnA5pY6BCFSrU4JoLmXoAQJSpZamL3XYdTmu5TV
I8pjuVM6CeCo4xHktcQTfaC/lJIEeLaPsQvmWqg9BT2wJQPRd3NevpH3LtiPGbuc
AUxqNwg7URUI7HzAPrzIZ8RV0BUmjceLkQluEN4fnN6bwOmtOgPre4fhiUq1Nto0
UOEteN2RT7Qm2BezJfQeNKj56Jc6PSH1U9y4tgOZUhtqJdNln+gKF+wIvE97Amyx
E7XI6f4ROX6KA2rHzEDSpx3docT7ypiN5LiuaxXAhBBHH4cnpru0Wm+Gl37vhNVQ
uQmhBTAZIQA67PCTUHL4
=e/MY
-----END PGP SIGNATURE-----

--RTD9Hr/VfB+mRRII--
