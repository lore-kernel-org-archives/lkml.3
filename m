Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbbAMQSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:18:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52481 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbbAMQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:18:49 -0500
Date: Tue, 13 Jan 2015 10:18:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Peter Chen <Peter.Chen@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is
 enumerated in peripheral mode
Message-ID: <20150113161802.GD16533@saruman>
Reply-To: <balbi@ti.com>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
 <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
 <15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141125144544.GC6360@saruman>
 <CA+RfmHZRqMwiSAZ7kpn+0_8a+25O+hRKxGJuK6im6fX0dzB8Nw@mail.gmail.com>
 <CA+RfmHb9OQ1Y_c-93jgpWWfNpTNLE84+Z70bOMtNrbJhQSWQAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <CA+RfmHb9OQ1Y_c-93jgpWWfNpTNLE84+Z70bOMtNrbJhQSWQAA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 04:02:20PM +0530, Kiran Raparthy wrote:
> Hi Felipe,
>=20
> On 1 December 2014 at 11:09, Kiran Raparthy <kiran.kumar@linaro.org> wrot=
e:
> > Hi Felipe,
> >
> > On 25 November 2014 at 20:15, Felipe Balbi <balbi@ti.com> wrote:
> >> On Tue, Nov 25, 2014 at 07:06:18AM +0000, Peter Chen wrote:
> >>>
> >>> >
> >>> > usb: phy: hold wakeupsource when USB is enumerated in peripheral mo=
de
> >>> >
> >>> > Some systems require a mechanism to prevent system to enter into su=
spend
> >>> > state when USB is connected and enumerated in peripheral mode.
> >>> >
> >>> > This patch provides an interface to hold a wakeupsource to prevent =
suspend.
> >>> > PHY drivers can use this interface when USB is connected and enumer=
ated in
> >>> > peripheral mode.
> >>> >
> >>> > A timed wakeupsource is temporarily held on USB disconnect events, =
to allow
> >>> > the rest of the system to react to the USB disconnection (dropping =
host
> >>> > sessions, updating charger status, etc.) prior to re-allowing suspe=
nd.
> >>> >
> >>>
> >>> Hi Kiran & Felipe,
> >>>
> >>> Just two questions for this series
> >>>
> >>> - Will it be the default behavior for all peripheral drivers?
> >>> - If the peripheral driver's PHY driver does not vbus event, how to
> >>> support it?
> >>> For example, chipidea udc driver has its vbus interface at its
> >>> controller register.
> >>
> >> hmm, good point. Since it's so late, I'll just go ahead and drop
> >> $subject from v3.20. Let's delay only $subject to v3.20 merge window so
> >> we have some more time to discuss these details.
> >
> > I am just curious to know/understand why this feature needs to be
> > default behavior for all peripheral drivers?
> > If this needs to be default behavior, could you please suggest any
> > alternate plan/design for this feature so that i can incorporate them
> > in new patch.
> > Regards,
> > Kiran
>=20
> Just a gentle reminder to consider the patch.

sorry, for the delay... man this release round has been hectic. We still
haven't sorted out what should be the default behavior here, considering
some PHYs will not be able to report VBUS levels, I'm not sure what we
should do here.

If anybody has suggestions, I'm all ears

--=20
balbi

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtUU6AAoJEIaOsuA1yqREfjcQALW6PxeSnlre4Rh6ya/8vbcz
gl1GiGAxtFd8cVE79Xlwf3qzNydp5jacAjUovJAnxOkexCOtfbuoS4/mHUB5jv+C
ifn7PtTvVlYTS+FUpV7MTTIPjwNOaeEEx9hTvUajItqqcAvL3HMGfB08dnqdaYo4
hOl+idE5EgltmReiBuF9hX0CiR9R6WGYDuRKM9RjRdr0M3H+Y0GP4HTA3CKmXxNK
+ccoM/cJIXXQsjN8lQ5W3JO74fTU3M/88p7AMhIFfzckNlAltttXIJYL472FHTAL
tt274Gv76Nn3xMeuMp7AVpap4zonTpGH3dtZi705vC+mGweibdv66Lj4AdgZw+IM
OSmpQanm6YXqCFn3lNevhJ+aJsm915/ju2iCtR9pJ5ntPQN9V+vg0NsjbNVr1mEd
MKZ95NPPvkLLGBerJn+TisjHR4GYasFzpRQH9vFZXGXBnTq+GyGnjtWqE287ygAr
S4ima8HfoUnk5dAPA/C9FGfZCPRo3fu+s8qg8/yqKRMIDDM3BQV3/ByXKgL7Dojk
PNSOidOarmwOMqEj2X8JOelL9Gb3d8OtZF/WY1Pkr8GGHYlZOD0FWsBVOCcBDYKR
sKiZqBcv/iheRH/xv8HpAf4uuDaBbCx0OfzMuH3JiX+DWWntFiNZqmOylGw7U0Ed
1m2gp+Vz2Ln9Te51T7X5
=B2fr
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
