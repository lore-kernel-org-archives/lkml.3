Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3JBCny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 22:43:54 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:54868
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab3JBCnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 22:43:31 -0400
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 22:43:31 EDT
Date: Tue, 1 Oct 2013 22:23:21 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 70/71] cw1200: Dont perform SPI transfers in interrupt context
Message-ID: <20131002022320.GB22070@shaftnet.org>
References: <20130929192643.539596256@linuxfoundation.org>
 <20130929192648.304161702@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20130929192648.304161702@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2013 at 12:28:22PM -0700, Greg Kroah-Hartman wrote:
> 3.11-stable review patch.  If anyone has any objections, please let me kn=
ow.

If it's not too late, please drop this patch.  Sorry aobut the delay in=20
responding, I was travelling internationally and had very sporadic=20
connectivity.

The patch was reverted in this patch:

	c4fb19d21b003ec99ec490ba2cb60baffabc73f3

And superceded by this one:

	87421cb6010a2f6494938fbe0a95e1b096b3b7af

(Out of Linus's upstream tree)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD4DBQFSS4OYPuLgii2759ARAnR0AJdLZT1x8a1CMG4vdE2avBxjcn5QAKC8n/k8
GGM2t4oyyBrXLmlX8PwgYA==
=IOwc
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
