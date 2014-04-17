Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaDQG0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:26:12 -0400
Received: from mail.ovgu.de ([141.44.1.66]:43474 "EHLO mail.ovgu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaDQG0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:26:10 -0400
Message-ID: <534F73F6.7050804@st.ovgu.de>
Date: Thu, 17 Apr 2014 08:25:58 +0200
From: Matthias Graf <matthias.graf@st.ovgu.de>
Organization: student.uni-magdeburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic> <532C97DF.9010201@st.ovgu.de> <20140321201352.GC1338@pd.tnic> <533069E4.10002@st.ovgu.de> <533C1B47.8080709@st.ovgu.de> <20140416142232.GF16741@pd.tnic>
In-Reply-To: <20140416142232.GF16741@pd.tnic>
X-Enigmail-Version: 1.6
OpenPGP: id=BE42F9BD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Qo9TFqWdL9idibOv5RXdVP2na5H97EOOG"
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1600_1699 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, ECARD_WORD 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_SPECIFIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __IN_REP_TO 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __RDNS_POOLED_10 0, __SANE_MSGID 0, __STOCK_PHRASE_6 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0'
X-Spam-Score: Gauge=IIIIIIII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qo9TFqWdL9idibOv5RXdVP2na5H97EOOG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ok. I tried:

3.15-rc1 (16. April)
failed.

Bisecting turned out:
last working: 3.12.17
first failing: 3.13


Am 16.04.2014 16:22, schrieb Borislav Petkov:
> On Wed, Apr 02, 2014 at 04:14:31PM +0200, Matthias Graf wrote:
>> I now tried booting with a different graphics card (on the same
>> machine), and it resolved the problem. Therefore, it definitely has
>> something to do with graphics.
>>
>> It is a Sapphire ATI Radeon HD 4830 (RV770 chip).
>=20
> As Tony said, you might want to try a stock 3.14 kernel with the old GP=
U
> which causes the MCEs and see whether if it still triggers. If you stil=
l
> want to hunt this down, that is.
>=20


--Qo9TFqWdL9idibOv5RXdVP2na5H97EOOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTT3P2AAoJELO00SK+Qvm9rYQH/irUXdRKB0Wx2diUi2EKe1tQ
m+bWktBuWk/89aHQEpSf4U7KoaqNFPVSGcQ6XxO/sWVtYmkdrOBlv7XZ835N3I3k
kn+zD+7hzNipFsXIi1fR+RDHIRPRc7BIJcG+g1j8hbXAqyQ58eqVsJnozv4/Swh2
kV99FyR6Ryk5Em9hr65cNiOaPyVTT99l0ye3XHyAV2yUh/WuVR0OM0ki3xCz2QwT
R0OQeYdgu1cjplZblqygzt4gOpWdrMR6k+h5Gc/57bUKP0hob0ybrh0yX+ow7kAE
u5dA4i9dFDt5tgc5nU/CDE9y0kkZgHwoGCfqp3cnILo61gTKBnTgIKlbkF1aF2E=
=VHHW
-----END PGP SIGNATURE-----

--Qo9TFqWdL9idibOv5RXdVP2na5H97EOOG--
