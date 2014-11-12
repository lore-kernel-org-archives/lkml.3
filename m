Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaKLWbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:31:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40780 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaKLWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:31:52 -0500
Date: Wed, 12 Nov 2014 16:31:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141112223154.GP641@saruman>
Reply-To: <balbi@ti.com>
References: <20141102180756.GH31454@atomide.com>
 <5458D29E.50908@compulab.co.il>
 <20141104154231.GP31454@atomide.com>
 <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
 <515E660B-B65D-41EF-97F5-74E4DE8FDD13@goldelico.com>
 <20141112212027.GK26481@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oDto3OTLsk6uOlQH"
Content-Disposition: inline
In-Reply-To: <20141112212027.GK26481@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oDto3OTLsk6uOlQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 01:20:27PM -0800, Tony Lindgren wrote:
> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [141112 12:28]:
> > Am 12.11.2014 um 16:45 schrieb Grazvydas Ignotas <notasas@gmail.com>:
> > > On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wrot=
e:
> > >=20
> > > Pandora does, as well as GTA04 AFAIK,
> >=20
> > Yes. The trick is that the power level that turns on the device is a li=
ttle higher
> > and the battery provides enough energy for approx. 30 seconds until it =
drained
> > to a level where it turns off. Depending on general setup (WIFI must re=
main
> > powered off after boot) this is enough to boot into Linux and start ful=
l charging.
> > Another trick is to modify MLO and U-Boot to raise the charging current.
>=20
> Depending on the device and the boot-up speed this seems to work only when
> connected to a Linux PC though. AFAIK Windows PCs enforce the 100mA USB p=
ower
> limit until the device is enumerated which can keep the device in an eter=
nal
> reboot loop not being able to ever get the charging going :)

this is actually what the USB Battery Charging spec requires us to
implement. If Linux is doing differently, it's a bug on Linux which
should be fixed :-)

No host is allowed to source more then one unit load (100mA in LS/FS/HS,
150mA in SS) until the device is fully enumerated. Host are also
required to drop max current budget to 8mA (IIRC) if the device doesn't
enumerate for however many minutes (I guess it was a pretty long
threshold, something like half an hour or so. My memory fails me right
now).

--=20
balbi

--oDto3OTLsk6uOlQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY9/aAAoJEIaOsuA1yqRERWsP/RUYuabRwR1hWbpKpTU5hhnU
pYhODCI1EN7NnEMVnAognL1ZqLvBM0F5QCQxIDILszkswBtkVBLQxvjneIvrQprn
q5Yiz5lhJiJzbEqogmm+4WUzVhhaGVhbB/jQsCJZuv5XKJVO+/D9ylj5puACZNfV
NqmR+cwhbW+Hv5lu9rD7oQhtcuaBoPp3U4DejsePLwOq7emC4/A2aHyussMrqvs+
Say3BRoEkXRox9xI2hfA4BnnQlpwyRpjZiFd7TIHqeVG7h5VLyA17WuInWqhAMn/
lhuO8QotJHd67FjAliVTSvQX/wAuYpjm0XknvsURHDuFEokYbkoy0Mf5XYjEEMNo
fBct3yio+K9aIFTBGXDHnj7B7Dktw0+WfSbcQkY3c/Tu8T2bbEuhAb/4Jy7imY1B
R7DKn3cm1xREloDJlMQNsEUN3fieVn92K+2LOB+JB/sdx8cc/2HvX2sHY6F8nqq7
jns2ax5nGnOehakQr+f79MGnujOELKOh/3NFIzNwiTHXwyjxB3uPag34iD4g4lWU
TEJX1buTI+QKNk9o8gHRf3M5x7JAAIUA8yKB5kWLEVqcI0aYVz3QrqrvukA+uOlB
Ko3TGNg0qEyTeEhpYQzLH9+3ik7FGFTIafZmqBVT6ZuGHFnEKQXnNZioe+qPyFhn
nmxXDvg3xSXNL1/TsXQv
=KRB2
-----END PGP SIGNATURE-----

--oDto3OTLsk6uOlQH--
