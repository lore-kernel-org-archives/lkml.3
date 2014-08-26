Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbaHZKId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:08:33 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:35921
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaHZKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:08:31 -0400
Message-ID: <53FC5C79.8050102@mind.be>
Date: Tue, 26 Aug 2014 12:07:53 +0200
From: Arnout Vandecappelle <arnout@mind.be>
Organization: Essensium/Mind
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
References: <1408709666-5927-1-git-send-email-arnout@mind.be> <1408721456-8101-1-git-send-email-arnout@mind.be> <20140822211247.GB24407@sirena.org.uk> <20140826092521.GH9574@lee--X1> <20140826094619.GG17528@sirena.org.uk>
In-Reply-To: <20140826094619.GG17528@sirena.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bERNSq7txhqwaOhkoIM778DkotaqOP6qP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bERNSq7txhqwaOhkoIM778DkotaqOP6qP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/26/14 11:46, Mark Brown wrote:
> On Tue, Aug 26, 2014 at 10:25:21AM +0100, Lee Jones wrote:
>> On Fri, 22 Aug 2014, Mark Brown wrote:
>>
>>> On Fri, Aug 22, 2014 at 05:30:56PM +0200, Arnout Vandecappelle (Essen=
sium/Mind) wrote:
>>>> From http://www.ti.com/lit/pdf/SWCZ010 :
>>>>
>>>> Glitch on SDA-SCL not managed correctly by the I2C IP
>=20
>>  drivers/mfd/tps65910.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>=20
>>> Applied, thanks.
>=20
>> Eh?
>=20
> So, this is an example of why it's important to both use subject lines
> matching the pattern for the subsystem and try to select CC lists
> sensibly.  I've dropped the patch.

 So, what is the proper subsystem in this case? mfd?

 Should I repost with the subsystem in the subject?

 BTW, while I'm asking questions: is this something that should be sent t=
o stable?

 Regards,
 Arnout


--=20
Arnout Vandecappelle                          arnout at mind be
Senior Embedded Software Architect            +32-16-286500
Essensium/Mind                                http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium           BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  7CB5 E4CC 6C2E EFD4 6E3D A754 F963 ECAB 2450 2F1F


--bERNSq7txhqwaOhkoIM778DkotaqOP6qP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/FyIAAoJEPlj7KskUC8fKKsP+wci209q+rjhjJE0S7JWtW2Y
yFjN41Y2+TMkPzKrhGAeWtb3rccPIAsq+ATXMoQHKCrlxrdM6YMTLKuXfEsWGvuH
2mQkfEC+6io9+S8+8u1fy0wUf3G9ZOm5AKEj+4Whr/tS+SLLUqcam6rmfXTM8wXq
x6wAcJVOgG42RrfWlDuNfL+aROfh/FJ+nQYHGlapNLiMc5d8ayw9QmyxV4OakQpI
WKjWvN48oi10XVeu0qBUFZ9FvxSssY16D+D+ubYzL2/DIW5Ob6az033iuimKKwVb
x/ek0MiCOY2bu+kpmOJ6aAGzIkrhGX6t8MaMkmQ+JL4DVmPIH6Cw45zSrQHXJ1X7
ekO/9nNK1VteFYVkWbmfUZxoQnlXIA1gZYV4472pJkhRaBTtnZfmSUvx4C/aks/q
J6AJeyor9cIw1gG6uucxMbZ0fF6BhAZQfymcfOdHdWqx3gDnKArGlUlLT8rMM06j
EUk5214BM0ubFWsSyj3IKNrl0uNkzjcfJHC2q+Lw641Pr153EZTwDOCp5YGw1+kD
rFILjYsJrr+eUBIJ4FKI3UeGaq89Ydp50szDk9JIkvqNWqiGqqPS1vLruvp5gvjG
app1Hlkrf9fGnH0ddSpVyFLLOA6tOqy+xv2CFWeC581JdGM2USM7qncE4coiMgut
jI5wEURPOw+cnUa5sei6
=ev/i
-----END PGP SIGNATURE-----

--bERNSq7txhqwaOhkoIM778DkotaqOP6qP--
