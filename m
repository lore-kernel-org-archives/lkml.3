Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaHVSbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:31:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55664 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:31:20 -0400
Date: Fri, 22 Aug 2014 13:30:54 -0500
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Message-ID: <20140822183054.GY24407@sirena.org.uk>
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>
 <1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>
 <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
 <53F73472.8010609@collabora.co.uk>
 <20140822144531.GV24407@sirena.org.uk>
 <53F7838F.8060906@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2+XEzv9QEhmMrrEN"
Content-Disposition: inline
In-Reply-To: <53F7838F.8060906@collabora.co.uk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2+XEzv9QEhmMrrEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 22, 2014 at 07:53:19PM +0200, Javier Martinez Canillas wrote:
> On 08/22/2014 04:45 PM, Mark Brown wrote:
> > On Fri, Aug 22, 2014 at 02:15:46PM +0200, Javier Martinez Canillas wrote:

> >> Mark, any opinions on how this should be solved will be highly appreciated.

> > If someone could tell me what "this" is that'd help...

> Sorry for not being clear on that regard. By "this" I meant the problem
> reported by Yuvaraj.

That mail was rather lengthy and seemed to be discussing several issues.

> The problem is that one of these regulators is used as the vqmmc-supply
> (VCCQ/VDD_IO) so the mmc host controller driver disables it on
> MMC_POWER_OFF. Now AFAIK (Yuvaraj can correct me what I got wrong) this
> shouldn't be an issue since on card detection, the vqmmc supply should be
> enabled again but on Exynos the built-in card detect line is on the same
> power rail as vqmmc. That means that disabling the regulator prevents card
> insertions to be detected.

If the MMC host controller needs a supply enabling in order to do card
detection and it's supposed to be doing card detection I'd expect it to
be enabling that supply.  Why is it not doing that?

--2+XEzv9QEhmMrrEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT94xVAAoJELSic+t+oim9+sAP/0cqgmmXXz6iRp17Yz50SEe8
bmS8yZpJm8VkJ7Jc1qSX8UTWOO5GejWgFogjANm5zOqPCPDD0Sk7ZMn/O3Rep+kW
ZhuvT6pWFXetx5/A8EpS9JrsUIrSJ1kjyzkNvSFscom41Xfo58UzYY99abMg9im1
PpOAk32owkOogMzbWhH9r13UpdAcWP9AItIPNCuNV+VAOwfmcQS1bQtfbS4KwOxI
MRm9mn75bvzF+1xm2b92rrRgyX+qOVFsSrwL7u59xjU5rnt0o4/XUWr+GxiGmm3y
AgFZrFlBPDONZyxfqTZjtJhw281aQOS9R2YpAerGqHGRLvSxYKZAKdA9CstJ2bzP
qaRVvmPmsy/FZCioV6u5/ES6tekmoO0PHzehjRdwV3t+b0Mt5z0Ttx058VUSnj/O
z9Zae3HzOfuO3LFBHYaKWcErGK3VNbc9x9/E92pd+i0r/5zetEsifJjOZ8U2tigC
Ayv6v4AOJKxhpRt3DLyQh0NnYLO+Doxrbo2PBV1yz7CPIBGDytB81FW43iw/BV+a
GIZIXBDFMgMsP+G6SoMLoBAOS9NqbzsRG5FC9ZSDIM9hK77mfyj5DdGLHbDD1m2L
TbO67IEjTGHQ/Qxcsh+go69yzJYh3vkgDWnKSqUFArvTtxqRQSIl95jhv1u2Q8QW
+yIUmY9hsMtj7gDyyDDX
=0vDJ
-----END PGP SIGNATURE-----

--2+XEzv9QEhmMrrEN--
