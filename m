Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaDBOQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:16:15 -0400
Received: from mail.ovgu.de ([141.44.1.66]:43580 "EHLO mail.ovgu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaDBOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:16:14 -0400
Message-ID: <533C1B47.8080709@st.ovgu.de>
Date: Wed, 02 Apr 2014 16:14:31 +0200
From: Matthias Graf <matthias.graf@st.ovgu.de>
Organization: student.uni-magdeburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic> <532C97DF.9010201@st.ovgu.de> <20140321201352.GC1338@pd.tnic> <533069E4.10002@st.ovgu.de>
In-Reply-To: <533069E4.10002@st.ovgu.de>
X-Enigmail-Version: 1.6
OpenPGP: id=BE42F9BD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uP774GoEoQv8QvoqalGi7304ObbM2tAXk"
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, ECARD_WORD 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_SPECIFIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __IN_REP_TO 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __RDNS_POOLED_10 0, __SANE_MSGID 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0'
X-Spam-Score: Gauge=IIIIIIII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uP774GoEoQv8QvoqalGi7304ObbM2tAXk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I now tried booting with a different graphics card (on the same
machine), and it resolved the problem. Therefore, it definitely has
something to do with graphics.

It is a Sapphire ATI Radeon HD 4830 (RV770 chip).

Kind Regards,
Matthias

Am 24.03.2014 18:22, schrieb Matthias Graf:
> Yes it also fails booting into runlevel 3 (no gnome).
> The screen freezes a second after the login propt appears.
>=20
> I could not retrieve a log of the failed boot in text mode. Attachment
> shows reboot into failing kernel, freeze and reboot into working kernel=

> (again).
>=20
>=20
>=20
> Am 21.03.2014 21:13, schrieb Borislav Petkov:
>> You say, this happens when gnome starts. Does it also happen if you
>> don't start gnome, i.e. don't start X at all? Try booting into a
>> runlevel without graphics.



--uP774GoEoQv8QvoqalGi7304ObbM2tAXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTPBtHAAoJELO00SK+Qvm9BGkIAKXzu/PcOisJwhGkFQX5c3Nc
EaSH8WE28qKUUYqV8IDtXB+3B8uB6nhAN7T/G3xqSiBV2AtFeX0m6+gGqHkyUJlH
VggFSjRPLD12T8a5t6yr59PXhnWdMszPtk8XYC+03XkWgo7MJOLwKc9r5sHkuGsO
nBnt2i5MDhnFifQKvuyGiWt0AxO0U9RbMrTwg/wwoEi4VQhA0hoifp7yNAjMmzwd
/i9b+tnaifQJW9CnNeQH+H3e32DJfTukDFyMClKkxToBWT9FgyXcQv+Nuz8vxFFg
vTBw8UjaXe7xscnI8oN7UiqjViADUlPQLIVbjv4sSMlzTVwtf03eyOYT3da2yCA=
=lkwu
-----END PGP SIGNATURE-----

--uP774GoEoQv8QvoqalGi7304ObbM2tAXk--
