Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaJPNWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:22:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44704 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaJPNWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:22:06 -0400
Date: Thu, 16 Oct 2014 08:21:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141016132155.GC3480@saruman>
Reply-To: <balbi@ti.com>
References: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Thu, Oct 16, 2014 at 01:11:10PM +0530, Sudip Mukherjee wrote:
> sparse was giving the following warning:
>         warning: context imbalance in 's3c_hsotg_ep_enable'
> 	        - different lock contexts for basic block
>=20
> we were returning ENOMEM while still holding the spinlock.
> The sparse warning was fixed by releasing the spinlock before return.
>=20
> This patch depends on the previous patch of the series.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

this should be patch one so it can be backported to stable kernels.

--=20
balbi

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP8ZzAAoJEIaOsuA1yqREbSgP/j3i9KqGrcQZsu04elNFLRLy
Lzbggtoytgx53bZJwlJ7wwYckipRFXpy22lCIHvhvak92zGOhjk2h1r+6fmQZDAi
jIpEBDVK+fgnNpQkgTupSk/Bxi8Ju4zmU+ne0L4o1RRcBa5nDOZ6sdOqwKB/qnPt
xbaueqAI+eBBUkUZIw436AAOr6HfTPwQt1JFcyKFLSWBxVERm8T4gV36yuSijuvw
AGXrICH837nqAkN7w5xwrna402bV6WdrrAxocSgCBi+0oILQS5+Y81cNHPqiIVWQ
5lnDksRkpKyXDokm1+trL3gUYt4Ut57F/YfL2EutHN5+Zu2/3iISk938U0LIigAM
r+AXVa04fYODTd5+Zp+qg1C8NyR1zcX1djE3c29WlwYqsQtEt7tyCJfPW8N/5j35
Af72JhjN2cnSBzxeohTkB9rjSkbXd2X6ez/Y/85UokL2HoRxNpPFfxec6GRPFkqh
c5EdR+Jt8cJUAcGiASjEWiEvZdgU+ROzhEuOSEzi8t0Cp60e2N/Xwm9vb01pHQFk
UEs4Z9e8YWKA+3bsz/IfbWPiiaV/lqOE4eCUTa/QXgChTiEC0gdk3Ma5U/As4Tve
7H1sgdt22rVzm6/6ik6FSFhC7/Aewh2Hb9OVE8HqbzoMnb9IzpeScqpvVpMmMoCp
Y/JaSAWxgRO0BvsEWM5W
=5G8T
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
