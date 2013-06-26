Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3FZJ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:27:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:1324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3FZJ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,943,1363158000"; 
   d="asc'?scan'208";a="360707711"
Date: Wed, 26 Jun 2013 05:18:08 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
Message-ID: <20130626091808.GA18468@gchen.bj.intel.com>
Mail-Followup-To: "Luck, Tony" <tony.luck@intel.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
 <20130625063257.GA2274@naverao1-tp.in.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31C53805@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C53805@ORSMSX106.amr.corp.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 04:31:23PM +0000, Luck, Tony wrote:
> Date: Tue, 25 Jun 2013 16:31:23 +0000
> From: "Luck, Tony" <tony.luck@intel.com>
> To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, Chen Gong
>  <gong.chen@linux.intel.com>
> CC: "bp@alien8.de" <bp@alien8.de>, "linux-kernel@vger.kernel.org"
>  <linux-kernel@vger.kernel.org>
> Subject: RE: [PATCH] x86/MCE: Update MCE severity condition check
>=20
> > The SDM talks about "non-affected" logical processors, but perhaps we
> > can call this an "unaffected" thread?
>=20
> "unaffected" sounds a bit more natural (but close enough to the wording in
> the SDM that people should see the connection).
>=20
> -Tony

If this patch is OK, would you please help to update it when merging
it? Thanks very much.

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyrHPAAoJEI01n1+kOSLHUaYP/1PI4Pzwv7OORGG1XGAAqp87
U7b6z6sd9Hu3LMEJFgLymxXByloFyvyahJLF/qAh3N6pY6dOtSnh0v8qLuU97a+4
VIpNC+z8t/h57YFQMOEBakfGBnjS7mOKo0+t/Mts9jYPi5w9LWEo4aGkILh9Q7f7
ly7jRM4DGDeJbRn97SyZvgJvTWuE7kXCKxfKEo8gMwTeZk4h+Tz6FNqer1MzZ0E3
Q/XPtFJ+2pHbk4087WLAq4TuaYTmyeYICWZ23KIvcb3hdnZ03MWOrs9ZT59+gCpI
9BscHJCu6LfNl619FVwARe4A8FsSNa4TzIDGqoUxSDJ/6FTVnIGH5MeF0pCxQ6Uc
lIuM8cimWVDJr7lCSXmys2JmhlzBtqk/f4FlrMsg0ODrlpZLxDGln0R/xWJANN0n
GwC3VPK0xUgi/T74fzGoBOxIdxCFblzlTZeN/jZyzBERUqI5LGEybbyjJ+/0+Ut2
XArqqXPORPZ6ZEnZiekzCrR3n1TBDAcZqWK3+NFdkXaQbtnX+38+u504TRnJLb6x
OrHZ6JR3p7ohXF5zPLvlMDJz+XxhznIPAs7aCRoyUZsWIpmKabAI7Tx/fxDS94KK
HMRZhYPMfydwszmFbiw2ywccpixleZolST4ptE+vrc5daHPWdLOl9wzeQybnIuoZ
2eRqBpZQcAWTY/6N7uY/
=mfRn
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
