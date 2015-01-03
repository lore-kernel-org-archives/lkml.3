Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbbACQzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:55:08 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55313 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbACQzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:55:04 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Date: Sat, 3 Jan 2015 19:54:59 +0300
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:11375 [i915] in
 3.19-rc2
Message-ID: <20150103165459.GA3020@yulia-desktop>
Mail-Followup-To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@intel.com>
References: <20150101142215.GA2570@yulia-desktop>
 <87bnmh1vee.fsf@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <87bnmh1vee.fsf@intel.com>
X-PGP-Key: fp="21AF 2E6F 04EC 7E11 21C6  E399 2236 2F26 57A3 AEAD";
 id="0x57A3AEAD";
 get=<hkp://pgp.mit.edu/pks/lookup?search=0x22362F2657A3AEAD&op=get>;
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2015 at 09:42:01AM +0200, Jani Nikula wrote:
> On Thu, 01 Jan 2015, Andrey Skvortsov <andrej.skvortzov@gmail.com> wrote:
> > Hi,
> >
> > this warning does not exist in 3.19-rc1, but it happens every boot in
> > 3.19-rc2. If you need any other information or data, I would be glad
> > to help to debug it.
>=20
> Hmm, at a glance I can't find a commit that could be the culprit. Can
> you bisect between rc1 and rc2 to find the bad commit?

Sorry, my first message was not fully correct. As I tested this more,
it happens unfortunately not every boot. And this is not a regression,
because it happened couple of times with 3.19-rc1 too.

This warning seems to depend on the previously booted kernel. If I
boot the same kernel every time, it occurs very seldom. To
reproduce the warning I booted v3.19-rc2 and v3.19-rc1-g08b022a965 one after
another many times. In this case the warning happens with probability aroun=
d 50%.

> > [   12.848428] ------------[ cut here ]------------
> > [   12.848479] WARNING: CPU: 1 PID: 328 at drivers/gpu/drm/i915/intel_d=
isplay.c:11375 intel_crtc_set_config+0x3de/0xb36 [i915]()
> > [   12.848482] WARN_ON(!set->fb && (set->num_connectors !=3D 0))

--=20
Best regards,
Andrey Skvortsov

Secure e-mail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD



--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJUqB7jAAoJEAF8y6L1SLCtePAP/Rb4Qv/7JNhpEOtOkSo0l43G
ejFd/j9BE41R0guaM5G0VfwUo79yp3S9BmHSPOH/ExYSt8Z1cQ1loLYomKPyNkFV
/1HBochlU8OHn2GIUjH5KIa/IlmN+aQJ2FwKTmBg6PRfPeUHEp/0/MWNBSUPfMRv
59/EAjV920WpG++tf1yzSARJQw1Ok21GWueSnOAe2z1gUCL8wS/nAO9CmKaVJISp
kOnm3cDYDnEjqj5tcCJCfGQEl9bKhIe5rCCIKnUfyKSmd7FAqAaw83L+CvOlg4Kt
U2ZTM7y/rn/Eh0Pj9on/6wxdmRjWItpvxcW6bv824oEFWlnYGdJutiqO3HIGMLSX
jY2Pjz1EtgN18peAhb70IxnYlYsGM7jQN2IfxU0DvRpC45r77hpYQVc3Pgwb8SqQ
gFYXzRRj9Cn4UarV7FJCKCd//Ag3OKnbB0or33hw7WXyllCeFBfGLqrFbkLKy4sv
oNAY3quGK1+/M2HtNUboqynJ90MAfLQS9rWKaFxY2AGeI1P+8dzkQaprjf8lWX3C
it//fdI63DTJp3eKQr7SbvcHUeNXAm1LaHIoINAYgXRDRiG6i9rpEUNJm24y/YA6
tleLqclmKTiPLdC8T7ZjaE1qA/fAVGfJtmDb33URwaJV099y/OESKNWI7ynGs+O6
xSh1JnrBCNAob1Poedrm
=xOhg
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
