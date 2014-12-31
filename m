Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaLaIzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:55:32 -0500
Received: from mail.ludd.ltu.se ([130.240.16.30]:33675 "EHLO mail.ludd.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaLaIzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:55:31 -0500
Message-ID: <54A3B9F7.4080808@gannon.se>
Date: Wed, 31 Dec 2014 09:55:19 +0100
From: Jonas Lundqvist <jonas@gannon.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Move two seq_printf's outside of locked mutex
References: <1419976466-2113-1-git-send-email-jonas@gannon.se> <20141230225211.GB31616@hudson.localdomain>
In-Reply-To: <20141230225211.GB31616@hudson.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tXjPh5Uqja7uCCBHKVu4xtldnvNUnAHVT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tXjPh5Uqja7uCCBHKVu4xtldnvNUnAHVT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Jeremiah,

On 12/30/2014 11:52 PM, Jeremiah Mahler wrote:
> You changed 'i' but you didn't explain in your log message why you did =
this.

I can change the commit message to something more generic. "Move code
outside of locked mutex" or similar.

> Does this change really improve anything?  It may work the same with th=
e
> locks moved around.  But if you look at the function as a whole, the
> locks encapsulate the body of this function nicely.  I like the origina=
l
> design better.

The locking was already done this way, ie after the seq_printf, in the
functions drm_clients_info() and drm_gem_name_info() in thr same file.
So this change is really more of an alignment.

Best regards
Jonas


--tXjPh5Uqja7uCCBHKVu4xtldnvNUnAHVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUo7n7AAoJEBKd4UpXCeED+DsP/3H7VzYXnfEFB5y5uvmPU0rN
BJQbd/xFhRHsFe2pN6dTRtsryV6N3mA4ce+yGnQ2eFjUgE20xRS3hjWnsPmRRF1K
i5btlEs6PkH/3c09ShxUNLIJZSxFLmRcfFtTDTo3t82+AV7AY7Ti5BrCYpL5vfJh
GDYnvYqAGzekEqrpGImDMBSe2MlL4As1I0F+EKunxgcs05aKkdn8kPUWis2urQw2
KipKMaG3o0/WIZ2YJY1VhnHibKJ4TEPtZHBMKmlnoD4IdZKFLTNAkLltCg6OagkQ
Q43GwA1BQNOz9tGfs3SMfOUToP6nDNxB4RHGWqys5LA9z7PGEIs0npn7HxY0Amk+
hh3ETWPZffGcXRGZnbtfLRkmYgouE7EmZk6gmOcrnO8YS5xXsWPRUvo8B/SjryqT
pL6T9z4zhr+RuscEg6TxwVTpaCQtEmPe8pNtDlU0zqSfNlEL/qT9Ic7UqZQgt1gl
dh8ZPywOS3LnAcfgpegW1w8VmQD21Wk20ecWiOWSSNHcxiamkCyDT9GND1UuAVKg
iqMTBSNEu/o8Xdp+WYqX4rSSQgCQQen3OpUaJMVtbyCC8ycj3zZxfDM60rOdAVOH
/QCzP90/LFavHT8euhE/oLu/WDCVrNBW+9sAkjcBXooeCERzmrH68ocXBEb542gX
VOAYTDIceLKlSdynqvq5
=h2Db
-----END PGP SIGNATURE-----

--tXjPh5Uqja7uCCBHKVu4xtldnvNUnAHVT--
