Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbbABPvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:51:33 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:52120 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbABPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:51:31 -0500
Date: Fri, 2 Jan 2015 11:51:23 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 7/9] thermal: introduce the Power Allocator
 governor
Message-ID: <20150102155120.GC10683@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-8-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <1417806260-9264-8-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Forgot to mention

On Fri, Dec 05, 2014 at 07:04:18PM +0000, Javi Merino wrote:

<cut>

> +
> +If you are using device tree, do add it as a property of the
> +thermal-zone.  For example:
> +
> +	thermal-zones {
> +		soc_thermal {
> +			polling-delay = <1000>;
> +			polling-delay-passive = <100>;
> +			sustainable-power = <2500>;
> +			...
> +

The above needs to be documented in the DT thermal binding document
too.

Cheers


--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpr5wAAoJEMLUO4d9pOJWVFgH/2hRXvDUZDT3oKEVKfvszYfH
J7IwmtSWO0cVUZIREIEsLa95ur5NYapFB5dRmc97Row6GxJtv7lpwi+XRFVqG3ZR
FFeK8vG+jg2af+NfzXLiB0TjDB3rbikZOSy9v5eeMcqCf0xJBpCfqv6A8Vrx0H8P
psuwEyAKXNj3D9xIFjdf/eLcsbKK1M4yWU5fuO2lfP0xwqXzxytVpr/xu8VIRcb1
/TgILGaknxo0++rq6E4Pw2pr6W9s0vcTdomRUL+jpeGwYLWUxwV7OBxaZO9pe5xW
eElgYII5pAqrPCb1l06AfLXTPn+Yoe9+RO56mpLrdnuQLKc1zvLyH6v1jasP2cg=
=2KG5
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
