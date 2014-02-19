Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaBSGbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:31:47 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53106 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBSGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:31:46 -0500
Date: Wed, 19 Feb 2014 14:31:31 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/4] of: Add self test for of_match_node()
Message-ID: <20140219063130.GC14031@pek-khao-d1.corp.ad.wrs.com>
References: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
 <1392762680-1498-5-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <1392762680-1498-5-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 10:31:20PM +0000, Grant Likely wrote:
> Adds a selftest function for the of_match_node function. of_match_node
> is supposed to handle precedence for the compatible property as well as
> the name and device_type values. This patch adds some test case data and
> a function that makes sure each test node matches against the correct
> entry of an of_device_id table.
>=20
> This code was written to verify the new of_match_node() implementation
> that is an earlier part of this series.
>=20
> Currently all but one test passes. There is one scenario where the empty
> "b/name2" node is getting matched against an entry without any
> device_type property at all. It is unknown why this is, but it needs to
> be solved before this patch can be committed. (However, this is testing
> the new of_match_table implementation, which still does far better than
> the old implementation which gets the precedence completely wrong.)

We can drop the above paragraph now since all the test cases passed on
the new version of of_match_node().

>=20
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Kevin Hau <haokexin@gmail.com>

s/Hau/Hao/

Thanks,
Kevin

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTBE/CAAoJEJNY7TDerrFxSrUH/3Jr8oBBifVwicj6UbNkWpwA
7qCsikQdidZLBq79gSbUVWA8maUumULh8oLUG8DMMyraVU1eFs9rvO7Wd7GMmTkN
+r2oFwTFxVumTNcvi2QYkbENwk2Z3477/dLCfIbJIUYKYKFf+Mxr4VS2kggd2qlw
bK7jVWChOQrPWBqWCJYwFhZeIfVwLwL/0SXm8VpYlPKs9GMMMF0H35Sr5pD6/w/i
Rvssz9XzmfMSpkVLzhRHhDhDLX40dshrrg3huKqIZ3D+5ORo2ZRdeBCUsILYardf
F8QCkPfbi2jpTBjWbGRoxPV+kP7QcVgHrjT1BgUk0SnszJ/QK/4d8NtiJfi/34E=
=/94d
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
