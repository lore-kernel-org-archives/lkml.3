Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3JNHEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:04:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:14214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3JNHEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,490,1378882800"; 
   d="asc'?scan'208";a="307399647"
Date: Mon, 14 Oct 2013 02:49:40 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: Extended H/W error log driver
Message-ID: <20131014064940.GD12189@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <20131011080427.GC18719@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 10:04:27AM +0200, Borislav Petkov wrote:
> Date: Fri, 11 Oct 2013 10:04:27 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: Extended H/W error log driver
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Fri, Oct 11, 2013 at 02:32:38AM -0400, Chen, Gong wrote:
> > [56005.785917] {3}Hardware error detected on CPU0
> > [56005.785959] {3}event severity: corrected
> > [56005.785975] {3}sub_event[0], severity: corrected
> > [56005.785977] {3}section_type: memory error
> > [56005.785981] {3}physical_address: 0x0000000851fe0000
> > [56005.786027] {3}DIMM location: Memriser1 CHANNEL A DIMM 0
>=20
> Very good guys, I've been waiting for years for this to be possible,
> good job! :-)
>=20
> Btw, what's "Memriser1"?
>=20
> > [56005.786154] {4}Hardware error detected on CPU0
> > [56005.786159] {4}event severity: corrected
> > [56005.786162] {4}sub_event[0], severity: corrected
>=20
> This sub_event[0] could use better decoding though.
>=20

What's your suggestion?


--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSW5QDAAoJEI01n1+kOSLHAYsP/3tIX91MNHuv+zAmNrq2lgqm
cPJXSJ8R7YEdlXouaGuP9mM8NQa7WPsEOIG8ydyRxWrYcK8NZApcucH9Arfo0X2q
sxftv9HDxI766IojUPR7Imd8WtSna5JSjXiPshHm944LFrY3+KRla4zpUhQzBonn
+IpqIiavPGCa/zpoSWFAopG2Li/yI2j7tWb3D56nuKW6IkRvTRU2cjploMTJEJkV
utpCcCxceZA/UJQtAdMqlqU7gDe2SitxQmFACx/OwzzlMQBIdRYYb+Uq6RxvTEnR
tNYimSDJnCQlv/1aBR4IZnWM1YrT6bQfeejRiLkQA1QNjqrl2LglF/bGwpiDr32m
oY/PK5YpUWLzeL1A17qIjvVZffdWe/Y1zFcbpNW0x4phFNJcQ4IoCVRq1haEReQC
hCsrzFSiBTYRZ2qWQBB72p/k/UhDoArNn0RVwSzD2DG5lYiLVPv1U5RbMDk/AX7f
xbwVwgt5RmF625qEQctI9WMZeR80aOgXRiKBhHRtv6u8tuvOIWuRdCtCVJjtFtPh
arvmI93LjoLPSfFPeN6Hsx+xY1jGUDxgREGfxrQpcjcLohTOfvMlOtI66WaI3nZQ
sADJvBr4F4HUfxt66w7kjG1iwMc8OFwRqnIfUwzK8L25//qw5+Igk4lhJnGiEsE3
lRitC7OpPkIZzHs2qF3d
=+VpZ
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
