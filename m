Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027Ab3EIEIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:08:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58566 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3EIEIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:08:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
Date: Thu, 9 May 2013 00:08:45 -0400
User-Agent: KMail/1.13.7 (Linux/3.8.3; KDE/4.6.5; x86_64; ; )
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org> <518B2033.80300@zytor.com>
In-Reply-To: <518B2033.80300@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2277095.4yNA0KM3iL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201305090008.47432.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2277095.4yNA0KM3iL
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 09 May 2013 00:04:03 H. Peter Anvin wrote:
> On 05/08/2013 09:00 PM, Mike Frysinger wrote:
> > When including these headers in the x32 ABI, the structs get declared
> > with 32bit sizes which is incorrect.  Use long long and such to make
> > it work both with x32 and x86_64.
>=20
> I'm not sure if it is okay to change the types, even within the same
> size.  Perhaps use __u64/__s64?

sorry, i don't follow.  changing types isn't ok (unsigned long to unsigned=
=20
long long), but changing to __u64 is ok (unsigned long to __u64 which is=20
typedefed to unsigned long long) ?

i don't have a problem using __u64/__s64, i just don't understand your logi=
c.
=2Dmike

--nextPart2277095.4yNA0KM3iL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRiyFPAAoJEEFjO5/oN/WBAPEP/18RlPFG/gaoNqa+mYHkSm6b
jRlvrc+Ig2lhI6kjzRN4qNmS8dnjznhv5oIbS2mpQzrjfOJDTM3lrkaRo77VkFIR
FxcwuouUYkdyaa2DRhctkxokZIWgdgINuFA7TNixiK45IDTRcZwm+/qUUe2JQzvY
tIyETN4L/mSitsQDCSZkRJPKacUqobDqhNEEseIy2ZMyMZMZ4/P1BgGJJeLUVZ1A
e0+jGT/yIRMOsjVZgY8OJ9JgtpK1zREOaufl6dFArrGgMBkYhkT/9fqYS7HoEisN
nU8bpk9FKUFqlqnFOOIGWdeDPBPHUjPglLaMaHeEeSL9SeCyN/olDOIvh8IKkm3M
QJjoJgNVNvHWeiW/fLTBCOwtkERuh69I+dHy7g7mCI5yfCb73L2BNgCHF5pasqFc
dVm9xgeSofJ2e4vL2jGMEi8DQDl8ESbIkhBFMMoIhJlrLgxxASZh2uA1svMmaRes
IqZDRtSd2CUr6v99C4sNDOzRlGLiE/KgeZzYNER5H0Cnc0VOo7/3o+63eZPD4xCL
7pCgWUKlRK3dHAZDDEZixsLt9SZ/UluwENopmhVT9IfF63x8VI9EXzAb9uBxWO3/
yzXkw8ndKtCd8DNnnNPaL9gMy0oi0Njau4OmtcFzf/osEtKHS7FTFvK1Vm338HsC
cNLgOhzRl4ooD6ida32f
=tqhG
-----END PGP SIGNATURE-----

--nextPart2277095.4yNA0KM3iL--
