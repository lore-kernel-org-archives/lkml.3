Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3CKH6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:58:20 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:62637 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3CKH6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:58:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoaAEyNPVFbdWOb/2dsb2JhbABDvzGFFwIBgVEWdIIpAQUnUhALISUPBUmIKrtijkRKB4JfYQOTEINEkHaDCzs
X-IPAS-Result: AqoaAEyNPVFbdWOb/2dsb2JhbABDvzGFFwIBgVEWdIIpAQUnUhALISUPBUmIKrtijkRKB4JfYQOTEINEkHaDCzs
X-IronPort-AV: E=Sophos;i="4.84,822,1355094000"; 
   d="asc'?scan'208";a="15563701"
Date: Mon, 11 Mar 2013 08:58:17 +0100
From: Samuel Iglesias =?utf-8?Q?Gons=C3=A1lvez?= <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: [PATCH 1/3] ipack: avoid double free on device->id
Message-ID: <20130311075746.GA6429@fourier>
References: <512DCB33.6030500@igalia.com>
 <1362730907-10047-1-git-send-email-siglesias@igalia.com>
 <20130308174701.GA13276@kroah.com>
 <513A29B6.9080008@igalia.com>
 <20130308193624.GD14144@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20130308193624.GD14144@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 08, 2013 at 11:36:24AM -0800, Greg Kroah-Hartman wrote:
[...]
> If the others require this one to be applied, in order for them to apply
> properly, yes, it would be great to resend.  If not, I'll just skip the
> first one.
>

They don't require the first one. You can skip it.

Thanks,

Sam

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPY6ZAAoJEH/0ujLxfcNDiuIP/2guo7qBEX2znMyUdnhVT6HB
sHL4psOX7TlgG/qcDcn92K5B9tMW9nIEaJ73XBXBpYKraFpPuC3F+IBw+tIte1i/
psGW+EK4MjNvgZNklrVWCYLjZMub0UYPjaKA+ixIQ5nLZTk/y6c2WzGfoVUbudTt
J/396sTY0vdTnb7Fl8sjjlfbZXOh/hrwXD8l+XEVhnhY9fuVD+2nDJQRBjmdwJtn
K/xFr3MNBxcxlImiwNlpruYoy6nzMQyxKjl9YTSh5MWRHXkuTUeNLrxwlnBEPcT4
MPvXyd1HNC2IXNy6N4eG6fFUcWabtuCHWo9zOPaKq6ByzPuIxKszYDaY7CLo7shh
MR0WYrA1zDOfdKNGQ7GZx3TdVbkYgUNlwvseatZzUlWU0d/kW3OOeVfq20Ea1CPw
UqbF8qWODULfBmDTSZxqoRdm4jamBzcrKSGaSfo+lPNsiiGuMnUFyLqBnLRN4vQC
AhpNA7xCi0OkzKgLJ1TkeiOe6nI/eR1qiqhfu+NFCsM2ABar95TZrieYfvLKTtHp
BCddzjz1ffctX3mFADHddUJyschFfIGklB6FhZanNvsOjDou/15ZXrMG69ZtLfp4
PPdTqYPuoO0M4jky3MJb3/ohT3Lu8SCRv3lSd3ddMTBOcS53aua/sZD8TWVSLsm0
VZTQNm1fM2dqyW9euSML
=1THH
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
