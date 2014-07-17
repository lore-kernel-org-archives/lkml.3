Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbaGQPKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:10:06 -0400
Received: from sauhun.de ([89.238.76.85]:38504 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbaGQPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:10:04 -0400
Date: Thu, 17 Jul 2014 17:09:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bastian Hecht <hechtb@gmail.com>
Cc: linux-i2c@vger.kernel.org, Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 1/5] i2c: Don't start transfers when suspended
Message-ID: <20140717150958.GA2901@katana>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
 <CABYn4swJ5NHyUd5+zCK6jhHex4v9DCMe5Qo-BZqxjPf90JfusQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <CABYn4swJ5NHyUd5+zCK6jhHex4v9DCMe5Qo-BZqxjPf90JfusQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 04:58:17PM +0200, Bastian Hecht wrote:
> I want to add the remark that I can't help further on the patch series
> in the next month about. So this is free to be taken/ignored/modified
> without any approval by my side.

Good to know. I'd like to get some Tested-by tags before applying to
make sure we have no regressions. So, with you being away, let's just
schedule this for 3.18 and we have all the time we need. Thanks for
finishing this code before you left. Have a great month!

   Wolfram


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx+dGAAoJEBQN5MwUoCm2kTAQAILjCU9YgdSrBzIrZlErvV7j
RCjYBuvlZObzxxkWsCmqkhWT0erU+UsBHzkVITCctnDYdgYJdE2fdJMiogOcxzHw
jjrj2P/+OWFuWtjaUnsCw5WaYWx5g8xnlirSmslEgw0M4iefKolRPnxYzvnSj2SN
6ldW/xomnMKtfUmq6havxHieGkC7LOwoIw9r3oEUmP6hyLfsAFOvHUrrL3Zw3XSh
0RG6hGEUYoX9CJUBQXPVoyntnHD7ehoYafrakXuiiBpOgIkXF/W54E5a6XFNViGd
XT6zQnmxK7kJ27qMGvEsGQGfKmNy5yLCCuwFnjIxpEu/FnODT+ZhHbNc1YPDkSf8
iU4HSymPE8Sfr5JOU2FACpFImOFqjXOWrhY0lLv0aA5xh2uyE2xmo62sI6jIl/5R
KUhJNnRClqCKLzZPz+z3KzCBLnJlSs5L9qiqo6tjsdemy0Sk1FJ+Zhu9GsOc85Xa
9M6KaANDmRRtUC2A0PRHRlUYLr7uBWCf148oX9RPDtxWOCp5xihbGtZ320uHtyOR
nj63qouwnwa/FHJDem97Dc+ujJViSBWC+FxiZoBgGtLhKdjzhZI7xlNBJ5S0zvJn
YTVdU2BPqddqFurC3Mc9l3Ub0w88+ZpposbRKVqxusxU8BIbTA1CEYkdctUoQkiX
Va2fWKGUdV3IcImsAwbA
=8ugv
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
