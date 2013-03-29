Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3C2RtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:49:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab3C2RtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:49:18 -0400
Date: Fri, 29 Mar 2013 17:49:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/33] regulator: ab8500-ext: New driver to control
 external regulators
Message-ID: <20130329174916.GG18316@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cotvrx6Jh20JAKQm"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-2-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cotvrx6Jh20JAKQm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:01PM +0000, Lee Jones wrote:
> The ABx500 is capable of controlling three external regulator supplies.
> Most commonly on and off are supported, but if an external regulator
> chipset or power supply supports high-power and low-power mode settings,
> we can control those too.

Hrm, this seems like a *lot* of code for simple external enable control
- from the changelog in previous versions and a quick glance at the code
I'd thought it was doing more than that but now I read it properly it's
really just simple enables.  Is there really no sharing with the normal
regulators?

Anyway, I applied 1-6.

--cotvrx6Jh20JAKQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVdQJAAoJELSic+t+oim9FJYP/1VR5RPAmgdk6hsZqC9OyFuY
/0Kt9wMG7sZ2TsHFaC6BRLyJVfiUDnM9lpOfnFBRqFr0Njw1J8NdUSHVA6vbnrHW
Wg7VNpskUXGAoyQ+A3TFJy8okgb9F0s9Pd0xZlytd51VcqdpsPBPd2HLVgY/Z8gA
kFlniS65QVCgZmX9mdAKS3RghmLRrj7sJe69YT4TiIw/uw10PawufXEWaxFh3XN+
FEyhSDeE5QCAP2F64eByvD7QZ/X4F5swLpa3f+V5Xzry+Jy8om5SYCeou2y+RD9Z
rvHllxkpUTCJqYbAEWO1G2quHpymtRnAOgQ9OaOk+61Hhqel6cRXXTgio0/vrO+2
pbdtmg1TRmMh0yCyE6xUNcFiu2Lgk1YGwtaL9dSlX+x295pjuLurdrXD67+jvFja
ccWmlsqzGF4zQebwmePGEO7vk+YsTNeqnr8q89dQhrakn4expig+a+/Xn3gMgAJ3
mFK7+EYF5N/yQR1NZrGyVRQCOh0vlNS4LySxxdw/OXZ/7wQ9p1/aE20eSq2eueYS
IghZxA414w3GfybKeFYoYRE78vMJMSzrtbSI65ItigkiLGjl0B2q2fNjKqzNac5Z
wiab79IC/dxyZtbdrAPtnOau4WrdI2Tif7eIxEbfT81pSxR0tL33CHeQXjroIpSM
zQMH5YzGRmpTN8E41mvw
=c4At
-----END PGP SIGNATURE-----

--cotvrx6Jh20JAKQm--
