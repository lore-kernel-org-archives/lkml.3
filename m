Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3JCNXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:23:07 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:54069
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753728Ab3JCNXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:23:05 -0400
Date: Thu, 3 Oct 2013 09:22:48 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 70/71] cw1200: Dont perform SPI transfers in interrupt context
Message-ID: <20131003132248.GD7167@shaftnet.org>
References: <20130929192643.539596256@linuxfoundation.org>
 <20130929192648.304161702@linuxfoundation.org>
 <20131002022320.GB22070@shaftnet.org>
 <20131002212609.GB12120@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
In-Reply-To: <20131002212609.GB12120@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 02, 2013 at 02:26:09PM -0700, Greg Kroah-Hartman wrote:
> Thanks, I've now applied both of these, which should resolve the issue,
> right?

Yup, for now.  Things are vastly better, but tester's still reporting=20
some oddities.  It's rather difficult do do remote debugging in this=20
situation, as I'm sure you know.

Thanks for getting the patches into -stable!

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSTW+oPuLgii2759ARAnL3AJ9fRdfWkuOgkDbYmRyDlH4irjkGMQCgyYa1
b/enHyISE/UO7UYH8APG+Fc=
=rZRS
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
