Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaAEXC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:02:29 -0500
Received: from ring0.de ([91.143.88.219]:46943 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaAEXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:02:27 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 6 Jan 2014 00:01:57 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140105230155.GA2681@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Marcel Holtmann <marcel@holtmann.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development" <linux-bluetooth@vger.kernel.org>,
	Ville Tervo <ville.tervo@nokia.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140103010519.GA27678@earth.universe>
 <20140105223250.GB27517@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20140105223250.GB27517@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 05, 2014 at 11:32:50PM +0100, Pavel Machek wrote:
> > > Changes from v3: Moved platform data into
> > > include/linux/platform_data/, something I missed before.
> >=20
> > As I wrote before Tony plans to remove the boardcode for all
> > OMAP boards including the Nokia N900 for 3.14, so you cannot
> > boot without DT from 3.14 onwards.
>=20
> Well, I believe it was agreed that DT should work for at least one
> version before platform support is removed.=20

https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/tag/?id=
=3Domap-for-v3.14/omap3-board-removal-signed

There have been some discussion with RMK and iirc at the end
the plan still was to remove the boardcode for 3.14.

> > The drivers can still be initialized the old way using pdata quirks
> > until all drivers are converted, but I think this driver can simply
> > be prepared for DT directly:
>=20
> Well, normally DT support means a bit of argumentation and bikeshed
> painting... I believe it would be better to get the driver in as-is
> and then work on adding DT support.

Maybe. Especially the UART reference may result in some discussion.
But having the discussion early means its finished earlier :)
Assuming this is not merged for 3.14 there is quite some time for
the DT binding discussion ;)

-- Sebastian

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSyeRjAAoJENju1/PIO/qacRkP/396yDvi9ieQ/T5nkfuQKql+
Oz89UdQaYdW17cwXvB61/TP4TUn/FMXhlE2EIWmKTWNbW/s9pt5U5IK6jOtQDNyW
TLOmSEJpL2ta1jSC8lMlipMdflpgEBzhoOznhvRm/Ifnco2/zOY2kyy1XDAUyLyy
c251vg5BbI96QlRQzsxAdzfcjsH05L0Z8qD3Til/pznqH5Kew4ktVJHIH3qaNdTY
3bbGm4qPTCr2nNvk0tDi+56QT++1HuAnKhIkSVE9YLanRrrRAOUlyQ4VWMeIxKPL
rt+qZTE+hICqT4KMfGTIEyrIgKywAHTuwQ9DC5l5MwpT7g4y4oLWGBk+ztGrDR7p
G4/jmVZcI8pXrGgfnhOmJAclEwSm1TY5r5x2hQA1yUHgEVIHZdhITfaahegnd0a8
SJ0fFvw7nP2plIeAoBxrXYqZKWY6K5ZyJGdOOSO7+Y8qtnxo1kvIo5jJrHsbBpww
rIrcSyhNQF00fmRLfwTMd+d2z1w4oEobPRLzOvtAUYflNNqzfScUkP8OlRelLUQf
hheGt7w/muHl8pUskwZRFxobgyak96AXtRerWc3HLu87yDqTi8wO6qUewGnxtXZ/
RC3ZM2+GW4hCKfa7AeJueOzauJr+fs7O2hjViK8pIH1XtQSmPToh1jED+UIw0CnJ
UC5Hdi4QRvlpsih9T8zJ
=P+pl
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
