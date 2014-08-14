Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaHNJh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:37:59 -0400
Received: from sauhun.de ([89.238.76.85]:41947 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaHNJh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:37:57 -0400
Date: Thu, 14 Aug 2014 04:37:44 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        torvalds@linux-foundation.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Make I2C core able to be module when I2C_ACPI is
 selected.
Message-ID: <20140814093743.GB2824@katana>
References: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com>
 <20140812095321.GU1657@lahna.fi.intel.com>
 <20140813020250.GA2853@katana>
 <53EAD278.2010003@intel.com>
 <20140813070759.GB1657@lahna.fi.intel.com>
 <53EB1251.1000401@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <53EB1251.1000401@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > True, but only the I2C OpRegion parts needs to have I2C=3Dy. Does it ma=
ke
> > sense to name ACPI_I2C to ACPI_I2C_OPREGION (or something like that)
> > and only enable it when I2C=3Dy? Then we would have ACPI I2C enumeration
> > still in place.
> >=20
>=20
> Yes, this makes sense to me. I will rewrite the patch.

Ping. I'd like to send the fix to Linus during the merge-window.

Thanks,

   Wolfram


--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7INnAAoJEBQN5MwUoCm2tvEP/inMeqMpDs6bwVLqQt/7vrQa
mGV/ft1O9oVEj980Bs6VZ6/KSfWcDuwvambAbBuCcfrHCSfjjTpteGVFkaPuwCD8
oN2XKjrCoEfcrvXo1D4/GX9xPXwBUIrk+2ksi2CsF77puZLjTvmebZfrFMxmlo0h
ub6i21TRxbLdOrNNyL/IUhLAKi7DsIu0lqaEWJ9MD4KuX31LzMVVXO/wjEG2thZa
fNiXzZEwl7X01lHNgWd24x7Lp5qnnYpSBnkbM4QEpTyCKUmpLS5BLIvrdaRsrq3A
p6SyNoUQVD7nAppr2f8peiOXILlpAk7+J4i4v0BcJZ4Esdi7ebiMHWXbk5dafFCO
WPyxrrXD9BzjLNEFPnSVjU096QnhNoyyw6XxK3WQ5J0oeYdNPC9mqkFz8awDQbaY
HlriAiJeY5rM7sWljvL0VyTuDpOgPV3tCTCHUSpRwxLGKaHneVmKr6rNQTdo++NO
BB9FnHooBjFGVK7//6EHJP0QVM47LuC3Y9qN/c2M+h2tehyIrX38E/b7hQjNKQIZ
ouSZ84zL+Y0ixHUWYtWgCD50RSFHCv7+uCB7WugD36VjRCCJ6w3QK2GJw1BPkLU4
bCKb4ahqfOQuyCzA5+ingrl7We57JGQAcP98AOG9YwQe+zyx9ERC+yesaO6qIzb6
XkvaOvv2nZNcepR4+j4q
=RjZf
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
