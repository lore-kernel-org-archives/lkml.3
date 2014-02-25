Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaBYXvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:51:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51884 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBYXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:51:45 -0500
Date: Wed, 26 Feb 2014 08:51:39 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140225235139.GG2927@sirena.org.uk>
References: <1393322091-24427-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7uYPyRQQ5N0D02nI"
Content-Disposition: inline
In-Reply-To: <1393322091-24427-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-sai: fix Freescale SAI DAI format setting.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7uYPyRQQ5N0D02nI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 05:54:51PM +0800, Xiubo Li wrote:
> o Fix some bugs of fsl_sai_set_dai_fmt_tr().
> o Add SND_SOC_DAIFMT_LEFT_J support.
> o Add SND_SOC_DAIFMT_CBS_CFM support.
> o Add SND_SOC_DAIFMT_CBM_CFS support.
> o And SND_SOC_DAIFMT_RIGHT_J need to be done in the future.

Applied, thanks.

--7uYPyRQQ5N0D02nI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDSyIAAoJELSic+t+oim9mdEP/1bT3t1R2ymhc/JFmVeTnO5k
0E65OBwQYwnkFsicwM3alIqF+UkiGxnkLozhzO4UF6zwso+T0D7oTxqfuUpl9vA3
VsX4B1SS3VLkPdVD9Vzf/kZa8lFHTDIcccauAt6ewnqGYt4TFM8VO7tRN+Pw6dNH
JSLfKDz9vGRodZqxL24YudNz07acIdHkTiL+V87NGg1Fl0+P6FUBXx0hmjNsdKzP
9ezOpblDsuVu1eLTLyKaokrtQy/4VHbKLRzvszxgtJCkj4Gs7Ddh7XehiCk+7C0j
g4C+fIlk/X9NkQ9dZkPnsKN5T2z5qdP3K8xYDNf3t8CFds/m7zHCyShxxVVftlqG
86mGDy/6t601Z0aX3H67089XuDQnODb3isoNK+SMxiiMkq6X3D1BPVc1pzrGG58B
cUrXTxmJL3g5Rn1gOoBu3sp3G8EPZOwOLVEgsqdOVLdES+vVse0bJRvA5cm9mV6z
H3TysY8PxOHautcpIL3Uddwv7DRYV7i6CFFPBy7h2i/zN60CXWQtB/pCc3L8zpBd
rv1u97GqmzItA/fatwRy39Z3tMAtOqxssDpDn/ftak19q2bwjX4cD9XXKI1ZBN1X
JqSZ0s537sDH2rzlzPWF4x6VfBh9+D0AN9c2lCBQ6rgiF73hckX/ApuyxTEM1Ka8
pzWdesk7GnnEjFBgjaBO
=4gJh
-----END PGP SIGNATURE-----

--7uYPyRQQ5N0D02nI--
