Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaD1PDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:03:43 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38284 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbaD1PDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:03:38 -0400
Date: Mon, 28 Apr 2014 17:02:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, broonie@kernel.org, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pwm: ftm-pwm: Add big-endian support
Message-ID: <20140428150207.GD28443@ulmo>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-4-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOrJKOH36bD5yhNe"
Content-Disposition: inline
In-Reply-To: <1395377590-23537-4-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2014 at 12:53:10PM +0800, Xiubo Li wrote:
> Now for the following scenarios:
>=20
>      SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
> -------------|--------|---------|---------------------------------
>     Vybird   |  LE    |   LE    |     No
>      LS1     |  LE    |   BE    |     Yes
>      LS2     |  LE    |   LE    |     No
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/pwm/pwm-fsl-ftm.c | 6 ++++++
>  1 file changed, 6 insertions(+)

And this should probably describe in text what happens. The table may
look good, but you don't give a real description of what the change
does.

Oh, and doesn't this change need to update the device tree binding since
you now have an additional property?

Thierry

--qOrJKOH36bD5yhNe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXm1vAAoJEN0jrNd/PrOh+MMP/3UHzshvRhDwvm1LpAIu9SUy
jBQKgno8lAvmuAkteA/ZxFs1lvFyLpAnq6GpHkMK1cScVby7Ij77rxOy8poYaKvp
wXLMnvfWlPnD6Ln+FcqGnsIyaFxRDlxRs8d35oMd2pRIA9hvong4vMKsCn6XFjUG
6MKbB6jn9hMOA8UIxM3b81m6XxSZPwcJqdxAtvuS+/ZQ1V3CoG30B1mJ3d12Cwcz
qh0sCvQ3uuaeJvLtXaV71DcGKZkhbKbMQhsdaO9GAG/mr80I1RPtUDCptoavsDNR
nX3xCsTYlB53RhCL4lGpfamUwSjb1nbAIdwK1jyYniMMWw2+aT1U2UYA2RsqK7tI
PdHHnt5ZkrYy3L+QN1b1c4QHO5DxhDq6ZcQc6vPDD2kOQfgwCM5+UvydfWq8iwqE
Tg5u1H875TdMzYu3F6lxWvaqNoc6grQyNefLonUn8/1SE3+IWEmGtMZaHWS/XHHt
FW3uXl/yqrRo9W4VdrMzZkqPRdZ70h4/14O1pGtHcI/vKbT3xyTQxylvnJ4WkAqi
wxnTdAzrbhOok/dMpDwMa0X0PTY2v5kEHcrcIkyaLrZgxaUu9ADV63edHdmaSgrA
/mULjDFGx05DD76YzK9faVuDsI7dewDQ84RjEaV8PnaHl3ksxVOzCsZx+qXNDllR
4OavEcJrstcPY8Ahkakm
=lsXu
-----END PGP SIGNATURE-----

--qOrJKOH36bD5yhNe--
