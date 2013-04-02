Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab3DBIih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:38:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54948 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223Ab3DBIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:38:34 -0400
Date: Tue, 2 Apr 2013 09:38:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ux500: update V-INTCORE constraints
Message-ID: <20130402083829.GB23065@opensource.wolfsonmicro.com>
References: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdYgCxf9R1aU2QdPUBxErhK=E2tM=6L-yMLA_L3+ntj3nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <CACRpkdYgCxf9R1aU2QdPUBxErhK=E2tM=6L-yMLA_L3+ntj3nQ@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2013 at 10:26:12AM +0200, Linus Walleij wrote:

> I know that Lee's been sending off a large set of regulator patches
> lately, some include alterations to this platform config.

> Maybe it's better to take this patch into the regulator tree if these
> machine configs will come in that way? Also like Lee to have a
> look at this...

If it's touching the board constraints it's likely to have conflicts
with Lee's stuff, yes.

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWpjzAAoJELSic+t+oim9MBgP/0ID95UsT4S+98kv3ly/tnoc
tjMDc09/+tZhFGnlgS2qejYSpF3/eWiU3OKKYZMDNQ2fq97ZnM6RLAMNzdDBrACI
XoAJ7SBd7CZfY0kXM73Luje2C8/h5nVWUVQIDR5YTcTBSNh33Rh1bDiPpom0//Q6
Cmn91gM9kheAal+VbmZx/4PunxeNAallv0LBq2bV6bAUZuJ8EYpPThW93Zd2G+QH
YDVWtIEFetKKp0ILwiNBv/2hZZ6QArw4zld6s9XEPVbo80U8uVgE+0ggeeyHlm8w
O8BAt0nXtLOZvlcvf+TBZBHZvU6yRChSCdJyIrsa3nRIgbKte3H7WU7fXI2dTy5p
hIYpRDV/Ft5xjk0rq4HgvRIahglrL2V9ht8/KsMMsOGmvkmEuoXoTsmpk0x0wGYp
PRHmhegzQ/MCDvHSLETGQs7M14dcf0Dj26wnE/tzZAQSlbb9rX/RiqoJoB1xWCgI
u5wjxJ0uIbA2qzM9ufMraQwMGvItS0DpSqPX+mATyl+57hAAp1Y1hr2i2C+JHcwQ
jL3nwhNvOgSlKAnlMMd36Rv4UomhEUG+utq5cjUukSQ4AZqBFdfo2krEQO/pxAtr
d6nOZT7kACp5Erh3bKjMKbTdzfyzZbJ4OxB+b9DOrh0eS8PYn5xfqNqs/XW1+33p
ti6daAFb+KQ5JUR4ELkt
=PR6y
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
