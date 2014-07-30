Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaG3KNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:13:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:42065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaG3KNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:13:42 -0400
Date: Wed, 30 Jul 2014 12:13:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140730101328.GH19379@twins.programming.kicks-ass.net>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
 <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
 <20140729145910.GH3935@laptop>
 <20140729152705.GX12054@laptop.lan>
 <CAKfTPtC8kJuBRT4HsZnQhzH4k_qDaq4nybYR+UW7rk6_Yx9_NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T9ZmEEwwNkzOGLQ8"
Content-Disposition: inline
In-Reply-To: <CAKfTPtC8kJuBRT4HsZnQhzH4k_qDaq4nybYR+UW7rk6_Yx9_NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T9ZmEEwwNkzOGLQ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 11:32:36AM +0200, Vincent Guittot wrote:
>=20
> FWIW, you can add my ack for the new version of the patchset which
> includes this patch
>=20

Thanks, done!

--T9ZmEEwwNkzOGLQ8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2MVIAAoJEHZH4aRLwOS6r0IP/2i0I79jmP54v/vxMaq9a4U/
49Y4FVIxks2sFbzTfsrvzwgdSvLW+Snwz3LCT9/POZ03hcJUwP3o45jE/RlUWSRB
SS/77Hd+aU1hpnEHfXfXuFLYfcmYWR4jf0iLPLH1VehMCS22EWOvBUT8FEkypVlD
CHVigC/02tD9ctvPvlOieZK10sfGJdukebKUCC/Ik1zf1EcSjdBE5eNbV2UZAhqi
An9yTl92zuyrYZokeWj+GaPiyJp/Koev2GFwIp+8rfZ9b04I5pk0rppM+3DQpdvZ
+wOXGk/ywRTJxSrbJPKosdsMYfTctoRCFAZ0QQ35rXepy3lDys6/IovDQ7wS5lR0
/1hONf5XW1m9H5yDfnH+FA8TSX2Kt4emy/AcwaW77+J5gET9EbeIKcqodIWSW+6s
ko3pkuKzGxFiTw293ue9wIcbSNfk/RscBXb4yHMTz6JH7Q7f10j6YW/PZY9TZHjY
mqJwUDuWjBKPdUeyuJThzjKUzmzxxwBJUoj344XgWjbNpX9r85rDoIsNPKs0vGdx
/zO9eLRykUmCpmRvaR1yhmS6tJw9GRnSVzxAeptWIF8ZbF03AyDZxEgui8T4GzTp
xfI4rFlKvWeAUpACvWS3spDndL7RGFYAXK2aJ+DC8VYw2k7cP3DGgZxHz0KBacO6
X8BGfX+8uexPSHPY4nWG
=lHgC
-----END PGP SIGNATURE-----

--T9ZmEEwwNkzOGLQ8--
