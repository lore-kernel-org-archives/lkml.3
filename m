Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3IQP77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:59:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44532 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3IQP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:59:58 -0400
Date: Tue, 17 Sep 2013 10:58:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 6/6] USB: gadget: s3c-hsotg: fix clear feature
 ENDPOINT_HALT
Message-ID: <20130917155857.GQ15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
 <1378995532-32142-7-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jesV4P1FjH8FXPjZ"
Content-Disposition: inline
In-Reply-To: <1378995532-32142-7-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jesV4P1FjH8FXPjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 04:18:52PM +0200, Robert Baldyga wrote:
> This patch adds two fixes:
> - Property halted of s3c_hsotg_ep structure is actually changed when halt=
 is
>   set/cleared.
> - All requests for endpoint are completed when it was halted, and the hal=
t was
>   cleared by CLEAR_FEATURE, but not when new state is same as previous.

each fix in its own patch

--=20
balbi

--jesV4P1FjH8FXPjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHxAAAoJEIaOsuA1yqREfXMQALCyvGeIwX/fd/yOXjeIpcyi
3aYzoQOlSOHAImpXN1A5nRcgF4WdTJ+0fXES3Km7PDjn1Auucn/IsNBay+fLILxL
q+f25SuTqFAP2qIYWG8JakhPBip/2ljjZMZfoUV+bdzUX03/uA1UGmWBRxeWzwnR
7GO4v6ZL2zG9IauJ5kQeKbLPrnvKln8vrc91ttKctRf0YSzJ8iZyuuRaVwQkOXl0
Pj1fky9NTkb+2XOGqBMORTnBEsvUfQC6/npZ5jDEYnnGkd1pOG3YOK5yAjRfjsib
KGVRSVlKycw6NFIxlEYswWoK5UkkOwMnYjzBXb0fpwBta47UbIEKY5dJLEvACyvD
VNFAU7DHwDaSYIFv7blB8CetpQuyN+sXOoEcytqCbRdP0dLC51HLGSs79T60+ZmI
ilq4QIsA81IMjY6XORkJPd10ametvvjoohz7+9mdkvtzQjHzVcfneIW98C5HOycY
eG16lfNhai2MvsCyksgF62o38lcylGux2Bmx2lT+p/Cu0T2J7l6kkz5OJ10u+38z
RQ5k8bV3qRs96w/NPhcuFsKzrhpaSCoNAdgGprYVBkcydtWl9fYB5d9xuXeLKl9l
GxXFyjnVxU3iHDhNsa3KQbFg/rHEG3RVQ5dldiKOUVOPnRUQG1jL+QiUjol0yfBB
qVEWrF2HfjgXVwYLUCo3
=JBvB
-----END PGP SIGNATURE-----

--jesV4P1FjH8FXPjZ--
