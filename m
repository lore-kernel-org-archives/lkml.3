Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3EUSQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:16:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47470 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab3EUSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:16:23 -0400
Message-ID: <519BB9E7.8080401@ti.com>
Date: Tue, 21 May 2013 14:16:07 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <rui.zhang@intel.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging -> thermal: move ti-soc-thermal to drivers/thermal
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com> <20130521170302.GC20464@kroah.com>
In-Reply-To: <20130521170302.GC20464@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OIKCPWXLFPRQFBALQIGP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OIKCPWXLFPRQFBALQIGP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On 21-05-2013 13:03, Greg KH wrote:
> On Wed, May 15, 2013 at 11:45:59AM -0400, Eduardo Valentin wrote:
>>
>> Hello Greg and Rui,
>>
>> I am proposing to move the ti-soc-thermal driver from drivers/stating/=

>> to drivers/thermal. It has been some time that we have been fixing and=

>> improving the code under staging tree.
>=20
> This is up to review from the thermal maintainer and developers to
> accept this.

Thanks for your feedback.

Rui?

>=20
> thanks,
>=20
> greg k-h
>=20
>=20



------enig2OIKCPWXLFPRQFBALQIGP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGbuecACgkQCXcVR3XQvP0sygD/UlZZcCjus5q1bsDORqd4iUuH
emOSLT6nwgZ888wfcmoA/3BlJtakRvs81OJa780z5gnDGq8CIVoWCZ/Z7jx3dtE0
=zB75
-----END PGP SIGNATURE-----

------enig2OIKCPWXLFPRQFBALQIGP--
