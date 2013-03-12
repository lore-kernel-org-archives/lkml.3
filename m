Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab3CLSQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:16:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab3CLSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:16:20 -0400
Date: Tue, 12 Mar 2013 18:16:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: palmas: Use of_property_read_bool to read
 "ti,warm-reset" DT property
Message-ID: <20130312181615.GB19942@opensource.wolfsonmicro.com>
References: <1363102819.3160.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <1363102819.3160.1.camel@phoenix>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 11:40:19PM +0800, Axel Lin wrote:
> It does not make sense to assign return value of of_property_read_u32() to
> pdata->reg_init[idx]->warm_reset. Use of_property_read_bool() to read
> "ti,warm-reset" DT property instead which will return correct setting
> for pdata->reg_init[idx]->warm_reset.

Applied, thanks.

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3DnAAoJELSic+t+oim9c5UP/1G7YXmCZpUbJUPqqKV8zSBL
+1bx9PJy68WrngVRIGcdCLyFsXio5luiWBaeHtNU5zA8ZI328TVtEsz5fM22VRzF
LvAdW6smPuEupFmJl+0GHkYKc0/XOBq4iSKZwOpgvyPhx/MFhkXwJOHK7Um4CkkI
CKGKIfNbbkdJx2OHhWg7ASOVmoxOOZvpheALmABXz8vfr/Y/V7HU05mHf12gcDwL
OzPw1sf8GXLYMNwheh+Csz9W56mt7BZHPVmyGhoxqAxAfDu284O5Me7RbK0NDzzA
6QVJvjLCKp0q/4BtAKJ+YmC0l69p1Kkd5hl1Itrcpwl/SlBsiPDhpUvZJh92obH1
78GnhQZ+dIFYTRIHBTw9dKwMxLhTTvYHDFJ6BZOnylO4fTethLQPTlf82p81CWNk
/Ssuy1eIZVs75w2uzYxmKVbg5kiZ7MGhry0/CTFHZDRQBPLPSmSP5wS8/ix7PX21
E8vUAnz14PS2KcQbrvI5OlGEVPlK/Zq9NJjbYWlSgsD7W0ouNkfphRUVvxgBVcr7
6lTtnBInw7AIy9NnfmeZAXHiVNm30J7rEp20D+NA8NxYeYXO7lB9pFtX7QC2SXPC
4/1rOxrT524GkPlHBFCusLipaCIDsXsAHrX8pbRnO9084AqXZX9waU7/H69HemxY
CGjrLAQNyDuzWxiKajRP
=So+9
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
