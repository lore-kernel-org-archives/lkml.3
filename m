Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3LJQh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:37:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35038 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3LJQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:37:54 -0500
Date: Tue, 10 Dec 2013 10:36:33 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131210163633.GI22750@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
 <20131203095136.GF11828@lee--X1>
 <20131208190739.GA18977@saruman.home>
 <20131209093748.GA12675@lee--X1>
 <20131209161422.GC24047@saruman.home>
 <20131210085007.GO12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Content-Disposition: inline
In-Reply-To: <20131210085007.GO12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 10, 2013 at 08:50:07AM +0000, Lee Jones wrote:
> > > > > The code looks mostly fine, but the implementation of the commit =
logs
> > > > > seems lazy. Please submit a v3 using coherent sentences with full
> > > > > explanations and correct punctuation.
> > > >=20
> > > > example ?
> > >=20
> > > All of your commit messages.
> > >=20
> > > > that macro just helps removing some extra
> > >=20
> > >   ^- Sentences start with an uppercase character.
> > >=20
> > > > line of code and hides ffs() calls.
> > > >=20
> > > > while at that, also fix a variable shadowing
> > >=20
> > >   ^- Sentences start with an uppercase character.
> > >=20
> > > > bug where 'int irq' was being redeclared inside
> > > > inner loop while it was also argument to interrupt
> > > > handler.
> > >=20
> > >   < ---------------   50 chars   ----------------- >
> > >=20
> > > Please use the full 72 char (or there abouts) width of the buffer.
> >=20
> > I don't see any mention of punctuation problems, however. Also, you're
> > not complaining about the content at all, which tells me those sentences
> > aren't as incoherent as you claimed before.
>=20
> I didn't read them in any detail. I traversed through the patches and

so you gave review comments without actually reviewing ? how rude...

> saw that the formatting looked obscure on all of them. As I have come
> to expect more of your submissions, I provided a generic reply
> detailing how I expected the commit logs to be. I wasn't insinuated
> that you failed to meet all of the criteria, but they definitely fell
> short of the mark.

in what way ?

--=20
balbi

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSp0MRAAoJEIaOsuA1yqREBUwQAI5/PNtINleIwqB6nbB+l92g
vPE8IhmAxWYCawv+NE1jVQ8cSitP2GKtob4uWVBN3yFJOzMHIUC99ZCqsGJdvpid
dvJyytiwW75/7P6ze/NKmIB3YnLqakerNqMnlzxl81zcx6TbcqK77f6YFKJvcfDB
WoleQ4ECFb7iT1Xvj0Stq+Up76dYSGWYcpNBpK5w83iGxTCb7koGj8WEGSzYPQjv
BF9ETU0FrPB/6qbWcFu1LozTTGbLFJzx/sNq+O++J9zSmST7Vbg5HjlzLshs4Kqg
/wH8S5vayWU6/HiTS8nlYsG/t1lv8TxnI1WNtoKx5lVRGazfk0wSd3UY6WMik/DC
trtUbSiLUAwioa4QNy8KlXTdmC6CzDUJJSjC5HbIadniWyrHQFNPC6jMtke93UJG
f+VxafODbPQn0WeS0qJzWAiRyFtpaS2sFsoGsLtIMBF6D+62yT1kMaFfIjf0TWyL
V3hxxVvVTSJ4o/PlALFX+gJBUI4kZDXj9ikEUEtIuEHWP0Bo5CC5KowJSHievfF2
wQAtw20barI3BxPKIrqi6Tn3vdRMT94aChyXg8xKFQe4nS7K+xGUOzF0fzP4os5D
7LPIBw7WMF7DkO30hIS6vNKTf2E9aYMMCt+OLzT/AW3S5YJY0sWtCgp4NWuexiuP
bd9ba/29q6Sa+DNt7rO8
=8bkE
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--
