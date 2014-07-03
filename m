Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbaGCRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:07:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaGCRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:07:20 -0400
Date: Thu, 3 Jul 2014 19:07:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: kan.liang@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140703170711.GW19379@twins.programming.kicks-ass.net>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
 <20140703073321.GU19379@twins.programming.kicks-ass.net>
 <20140703155237.GQ5714@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KAk/33nSS6LK84p9"
Content-Disposition: inline
In-Reply-To: <20140703155237.GQ5714@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KAk/33nSS6LK84p9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 05:52:37PM +0200, Andi Kleen wrote:
> > If there's active LBR users out there, we should refuse to enable PT and
> > vice versa.=20
>=20
> This doesn't work, e.g. hardware debuggers can take over at any time.

Tough cookies. Hardware debuggers get to deal with whatever crap they
cause.

--KAk/33nSS6LK84p9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtY2xAAoJEHZH4aRLwOS6sXcQAJpgR+9ESw2VS5K46T1KqU1g
F03zUk7n6Sml80hIQ0vaizCOyi2xwqOKtIhYsdsBjVPTFR03eMSmuOZQhw1VN74r
x94ICaUpU3XVtk7/i1YJSjzCNCcnN/xXr+mugdLd7qDVVkOLZcxLWAXkokEC5uS6
dxd1oEvIV41Rx2uTouMTLgNNWifR84IItBr1zhUt4YDuEPSaT/vdyTbtIwiea+oz
GKDcwJFe5euKs1FyWl9A+D5E8enoxUr1+tm65Ig83Ca0WG7eX5SafvZW5uJN4EBu
E3/BWukEdXODg1JvqO1QmhLAxGVel9OwrlC8ATBkmdqIaTL7ce6+0y42Bpu6f+8S
Hl28YvI/CHSZ97v3A/pGjiMzDLvQbpBdJCEfw1WHfZUHzGnYXwpkASK1U6c0bavB
4j3gzbEwUQf5LjzBl1+qA5bQkEJjj/bftooiWxvmrMymwmYGk8w2Vs3lGPTkpVML
wavYPRFFiYnAxRWfnWkxLcT0qeL691YnDUlmSL/TTgfUX/sCedLiPn40a6v5J/eV
GGu9CvctSEdNslvsc9Dexo/INMjr5vTRkBYKa/Psmp8pObRtmshqL7sWf3u9Rk0y
u/T35e8PtsujjZp2evkhgx/Qg7kIjH9/HaSV4w+PqHQDJUV2vhx9oxW0DPKU7d8L
LzHiLB3D0tH4PBLlvcHp
=ACfl
-----END PGP SIGNATURE-----

--KAk/33nSS6LK84p9--
