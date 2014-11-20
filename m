Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaKTTys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:54:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57090 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaKTTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:54:47 -0500
Date: Thu, 20 Nov 2014 13:54:59 -0600
From: Felipe Balbi <balbi@ti.com>
To: Todd Poynor <toddpoynor@google.com>
CC: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [PATCH 1/3] usb: phy: introduce usb_phy_set_event interface
Message-ID: <20141120195459.GI23217@saruman>
Reply-To: <balbi@ti.com>
References: <cover.1416390389.git.kiran.kumar@linaro.org>
 <40513430786f3190776ee4a180c2486812048a6b.1416390389.git.kiran.kumar@linaro.org>
 <CAAW3YpYnnvM5thnGDEt+OkhpPF5+CP3yb9vJS=AZ_5RgyPsejQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Content-Disposition: inline
In-Reply-To: <CAAW3YpYnnvM5thnGDEt+OkhpPF5+CP3yb9vJS=AZ_5RgyPsejQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 08:36:22AM -0800, Todd Poynor wrote:
> On Wed, Nov 19, 2014 at 2:43 AM, Kiran Kumar Raparthy
> <kiran.kumar@linaro.org> wrote:
> > From: Todd Poynor <toddpoynor@google.com>
> >
> > usb: phy: introduce usb_phy_set_event interface
>=20
> Hi Kiran, this is new stuff that is all your own work and you deserve
> the credit.
>=20
> Thanks for working to get this feature in shape for mainline!

Kiran, what Todd is saying is that $subject is From: Kiran, do you want
to resend with that change ? I think this is ready to be moved into my
testing/next otherwise.

--=20
balbi

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbkcTAAoJEIaOsuA1yqREaccP/0N/2WFhe2Vl4mQlZUK+BNEW
p+zk36xpaPAA9avCdemt8TbxvCIhQkkEU/eNnG2ZYkREWXQ6pq+1fx2lnOMPWS51
W+yguzezCd+h9Xml1gB9mj28f+0ruPO/alt4kUYvovW3wp4Z0eYdiok0FIanrbGI
TNHiQTBobMfBpRGDbwAreb7xULGiDOARL1N/skH/Ah5nHf87sHqwwRxWNfsuKi5/
DmtQrSUnJUNV1sHaAlS9vRVdG9vvBfouu+dz2XxYngQre8RDxhyvsCJWmWZ+eRNO
Q5W4QHlyduSqnN+zsup+aajVifIhxDEFsqtnmt+d4FPVvJWE5Lw4gEuyMZMKAdEG
1zPibYkCvaaBvJI9a0HnX1JDoc2HSW9iVyYilzAGCBxtWi56PjW1vPMVlGo73tH0
Zalu6P3aJT2ByyPeJCvX4VJ6NIKFEyEAee6Wbc8uMiiph4J2NhuXg3zkenENcWIV
T6Fog2fltEjPvsQcVrVIL9gMH0EhGw/7+U9rNfksohCeG4l8CDx+0c/4z0ayexBG
GyJdrn1t/L1v5QfAIQi7XSyAscB0Ehx0LsOeoGHBcSeeCV6SK/KYVyzDCmvyFn53
B41jCMSA5Msp81QAulZqd4fHMrzPnxy3d4sgeqm0iITq/0ymvEWr6/GgY6KPhk0V
Fm9JmRXv6ojH0ne4745W
=BL/g
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
