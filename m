Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3IDV7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:59:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54775 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3IDV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:59:07 -0400
Date: Wed, 4 Sep 2013 23:59:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] host1x: hdmi: Detect whether display is connected
 with HDMI or DVI
Message-ID: <20130904215902.GB4661@mithrandir>
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
 <1377704922-2824-3-git-send-email-mperttunen@nvidia.com>
 <52277EBA.6030105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <52277EBA.6030105@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2013 at 12:40:58PM -0600, Stephen Warren wrote:
> On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> > Use EDID data to determine whether the display supports HDMI or just DV=
I.
> > This used to be hardcoded to be HDMI, which broke support for DVI displ=
ays
> > that couldn't understand the interspersed audio/other data.
> >=20
> > If the EDID data isn't available, default to DVI, which should be a saf=
er
> > choice.
>=20
> This seems like a bug-fix that might even be worth CC: stable?

Possibly. The patch reaches deeply into some DRM structures, which I'd
like to avoid. I'll have another look to see if it can be done in a
slightly different way.

Thierry

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ60mAAoJEN0jrNd/PrOhXCIP/RsOAR8/E432K+lCgHx8CHXN
/QD/Hqw+4s3yxKIQruJRPOZHn9Aq9B5lI0Et5GT+WhC/4WdnBGB2QcNeF0hhJl8I
LvDWPGTWbExVlt+HUQUeHvFf7Vv/J6eoXzn2HkKUuejLiQVTn0pB8z5lddRL/3LA
JMg3Cbduin+ITngUwimhNK6x3qRp4/dN3/2ugm7QYl83GQO9KVX+qCllDFDhvgne
uTPt515qtphsEQfZFpprdzpZasTWrIGyK3Wj/6jazF7bZqpnJQZsbg7phV2uPxlY
YheN8ONZ4Xac+TSoTLWSfAjkmw20G2eDiQeWW6hRcHuFz5GPg5HIiSaamn9H6yMn
/QX3yaZ3oM1FdpUnvbbIxZhtfigi/r0F+hvsCPcIS7nTr96B3mj2QkAUlEqcVAFJ
bQtrCPiX6U7Q1RNpjIu8ifFVQSvTS0EjuqZvvdP6AYsM5diwnHxFErGlH0c4K/rX
Lt0cf6/CbRIl+hPFRMg30CqzjvcgkkPl6406JSsrFWE5etwse2gYmPPLJ1q9+d0Y
2LoWEIbGXZvOAJlaIUjzoQZopY4gPjBXMXGuCyU8+YmbOgVpuoIOxJRkzZqgjnvt
4cO0y/nam5FDdoM0zbuqmRPMOgIyu5LUp//QGW4jLd5JCSa+gDCTNd6GN7iRW1EE
H8m7loUCHaNqH9tnv4W5
=OUEj
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
