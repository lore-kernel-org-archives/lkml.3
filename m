Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965897Ab3E2MBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:01:25 -0400
Received: from dotsec.net ([62.75.224.215]:42058 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418Ab3E2MBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:01:24 -0400
X-Greylist: delayed 2374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 08:01:24 EDT
Date: Wed, 29 May 2013 13:21:37 +0200
From: Thierry Reding <thierry@gilfi.de>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: thierry.reding@gmail.com, airlied@linux.ie, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, tbergstrom@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/7] gpu: host1x: Don't reset firewall between gathers
Message-ID: <20130529112127.GA8079@manwe>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
 <1369823168-5396-4-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1369823168-5396-4-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Arto Merilainen wrote:
[...]
> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
[...]
> @@ -553,7 +549,6 @@ int host1x_job_pin(struct host1x_job *job, struct dev=
ice *dev)
> =20
>  		if (!err)
>  			err =3D do_waitchks(job, host, g->bo);
> -
>  		if (err)
>  			break;
>  	}

This is another unnecessary whitespace change, but since it was the only
issue I saw with the series I fixed it up myself while applying.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRpeS3AAoJEN0jrNd/PrOh2eYQAIalDwI2qvEq7zcXb1KU33bC
T/jID0lqj22WDMeiJEhGtaxUq8cRJcRvLd7CIFipVS3Dqt/uTuGSq4m21j55Cl3q
RJhKmpaa9h3Kj/Fof6fQs4TWDVaf6qMT9KmuPC5fZhyDR6NpuYi8VkcYIL8U7azA
FNnR3cO1DKcK3xnuRxNuv6ntMaJIPzfWmmSX8ikMd71aGzjN3XWwDktYFR7FwnLb
UUTz+SUk+wefIdO3ZeQdRV0B0qlELVR1fYih7HhMfRdGmK0w8gb3iUHy228ThFcX
I20BuCn/iNr7czqnPH0S8Mi5ryLOdswY5SshzzlnA6O5oLHvaWjFDhlrpJPMEXdU
jT02xmvz1jqUseSjnsfdUa5QrsfTDuAXXhC7t/Pq6ChZQ0D/CN8/xXUiqymYPUlc
4AiFGojlYE2YR2c//emlCq0osPhvRaQcV+P1KpCpBai2M3umjfCtP7wK/EwnU1nd
n7qe4Nbrwb4rw4/7mRzS6YT7G40YsONqsVCjs/IvhIrAtQYtrqsDPkMafz63JYn7
3A8ix6PK8u+KaaHJoLf5reC8DHl8KueqF2vSkj0D0qnG6LOyY36gIiBniTJE8Yip
51uOHKf15IB0dz3X940VgoJlSSdPQVzk/nNbgy+lHW3VC7wuKzyen0tPv+ojor0K
OTQ3FJTBQTPDgYC/Voci
=yPnk
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
