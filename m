Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaDVPjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:39:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53558 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933134AbaDVPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:39:13 -0400
Message-ID: <1398181118.3624.203.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v5] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: David Miller <davem@davemloft.net>, zoltan.kiss@citrix.com,
        jesse@nicira.com, pshelar@nicira.com, tgraf@redhat.com,
        dev@openvswitch.org, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        edumazet@google.com, dborkman@redhat.com, therbert@google.com,
        jasowang@redhat.com, fw@strlen.de, joe@perches.com, horms@verge.net.au,
        jiri@resnulli.us, mst@redhat.com, Paul.Durrant@citrix.com,
        JBeulich@suse.com, herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 22 Apr 2014 16:38:38 +0100
In-Reply-To: <20140421112601.GC3200@hercules>
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
	 <20140327.152956.1528740039185894234.davem@davemloft.net>
	 <20140421112601.GC3200@hercules>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yXhVSZ4fAkZKhh5lQ3eq"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yXhVSZ4fAkZKhh5lQ3eq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-21 at 12:26 +0100, Luis Henriques wrote:
> Hi David,
>=20
> On Thu, Mar 27, 2014 at 03:29:56PM -0400, David Miller wrote:
> > From: Zoltan Kiss <zoltan.kiss@citrix.com>
> > Date: Wed, 26 Mar 2014 22:37:45 +0000
> >=20
> > > skb_zerocopy can copy elements of the frags array between skbs, but i=
t doesn't
> > > orphan them. Also, it doesn't handle errors, so this patch takes care=
 of that
> > > as well, and modify the callers accordingly. skb_tx_error() is also a=
dded to
> > > the callers so they will signal the failed delivery towards the creat=
or of the
> > > skb.
> > >=20
> > > Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> >=20
> > Fingers crossed :-)  Applied, thanks Zoltan.
> > --
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Could you please queue this for stable as well?  It has CVE-2014-2568
> assigned to it and I believe it is applicable to some of the trees.

It was applied to 3.13, but needs backporting to earlier versions.  I
posted my attempt in
<1397429860.10849.86.camel@deadeye.wl.decadent.org.uk> but it needs
testing/reviewing.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-yXhVSZ4fAkZKhh5lQ3eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU1aM/ue/yOyVhhEJAQrEZg/9EvsyUfx8GSmtrzqV7LVBTuzLyAysjdu2
iFQrjx4AZroLRPtOu2wE0C3JumJfk4Fo271Oy0vV9m/KriF5LN4M1+7b2i2MdJBH
kwHdIRE3IIN0KFVcQL5uFWv3k34CaUsLkg/SS0v6CC/W9PibguJQo/WnTmvNG8tg
WtFoec/X/n99PNZbfEobICZaEh14d+H60MTSOz38NOWsfXDn9Qjl/HZ+yQPe9+p7
YUEo8MemVP5ZRGe94dDMkW6gZ3bwfN+7XVtJ1KOePStl3nqiLGbg98MX/kCIFdrc
eze4cU5iUWmBoAzzIEVy7Fphv6FXXIHXWsMaf1+liEu3zOtcFowU0R2B06Ekz/57
cmt8MsfILPioBaDUspbZx3A5JwzBEnhgNDZWfYQVdt4D0n7M4BEvl43/wkhLAEFv
P9yUatDWHjbwYPAWPruQ9MvCLdTSdbU1P/UsTjrD741OlAMTDpPszzuy4Fq5W/QH
+U1/CQt50XbDpX5wo/cWtRt4Y7u8d0aaM1TtPPOo/p3RwAOJU4GdABpu6zQMq1Ot
ZKBQHKBqbZz3er1PDT9mWRN3jq0Ct8NHvVTgr6DpJn0+S72YJTGnrYEr33Rn+yml
AvmNm/r6yTqaEknEyOHVnhVsZMFOol1sGyShkvsCddOx8COEA//WZIn2BSljeMM6
YOfG/iGwSqY=
=57mT
-----END PGP SIGNATURE-----

--=-yXhVSZ4fAkZKhh5lQ3eq--
