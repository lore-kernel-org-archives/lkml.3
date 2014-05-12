Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaELIDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:03:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaELIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:03:18 -0400
Date: Mon, 12 May 2014 10:03:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH linux-next] perf: remove unused variable
Message-ID: <20140512080308.GK30445@twins.programming.kicks-ass.net>
References: <1399844629-32173-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jrSbkLCAP5lJDiYt"
Content-Disposition: inline
In-Reply-To: <1399844629-32173-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jrSbkLCAP5lJDiYt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 11:43:49PM +0200, Vincent Stehl=C3=A9 wrote:
> This fixes the following compilation warning:
>=20
>   kernel/events/core.c: In function =E2=80=98perf_event_exit_task_context=
=E2=80=99:
>   kernel/events/core.c:7434:35: warning: unused variable =E2=80=98tmp=E2=
=80=99 [-Wunused-variable]
>=20
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> ---

Thanks, but Borislav beat you to it:

  http://lkml.kernel.org/r/1399720259-28275-1-git-send-email-bp@alien8.de

--jrSbkLCAP5lJDiYt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcIA8AAoJEHZH4aRLwOS6josP+gOEuTCTfWiWmbLROQ13DeTX
fu5XAGc8nlMUrwOm9aJlD8P4hc5n0TQlUFJOJyp5kg+eYUUMjj/FR9rlPjr5uDgH
pzgZRvQ2sZPt9VJomQW3+98ntak4UAXVLi2aYr+qWRfQAV2Dk+9PsU/+ypvjs9dv
RVg+HoZlcqlW25xJ5E3cQzlZMqQw1O/MswpceZtvcZBmC5IBotQiM3b8VpLd3czJ
LECBuahF40PZW5axF1kfmGXS3yrfXBuDCIeUJE2+3UXk/640TIfgs4OK4Nn6YCRa
RREtlC3I6ZXRJazP09QehljxUpW6Ah5IUPIwDRRhadzJgGQWP6pRByEYYoMpxtbb
TX42DwbKmym7GhCa2MUVJTbfWWviEnFx51f9+cawRH8gW28R2OT6BsjBmPhPzvnY
N/1PiIUrbTDvUeYBUhyB8Xu7zenTNe2vuK1ajN3Zs6yZr5JJhnBmp4RfDmcPreuP
Asq5YcR3sjfIjYH7vMoh810xa1zHISt1ZEWeP8m7pIPw1vcXrH5953c5oYJcIIWB
5WF523mxP1E5Xa2E4dBnpkoQlNmC0XvvDoJ5lleqTZEZtlIT7BiI+YGt8tZg/fnN
RC45Wn/LBP3yGB1ZMuUv4wJOFppToX40ZkWa9qFxQunfiazzpYDzBxEDWAWH1nP0
BNqO8PRskaEMoiwLFGa4
=vubK
-----END PGP SIGNATURE-----

--jrSbkLCAP5lJDiYt--
