Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3KWQsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 11:48:54 -0500
Received: from smtp.citrix.com ([66.165.176.89]:21668 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab3KWQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 11:48:52 -0500
X-IronPort-AV: E=Sophos;i="4.93,758,1378857600"; 
   d="asc'?scan'208";a="77523651"
Message-ID: <1385225327.21937.59.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH RESEND v2 2/2] xen: enable vnuma for PV guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <akpm@linux-foundation.org>, <wency@cn.fujitsu.com>,
        <stefano.stabellini@eu.citrix.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, Elena Ufimtseva <ufimtseva@gmail.com>,
        <hpa@zytor.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <ian.campbell@citrix.com>
Date: Sat, 23 Nov 2013 17:48:47 +0100
In-Reply-To: <528B7C29.3050103@citrix.com>
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
	 <1384811922-14642-3-git-send-email-ufimtseva@gmail.com>
	 <528B5160.5010902@citrix.com> <20131119141620.GD5332@phenom.dumpdata.com>
	 <528B774F.7090902@citrix.com> <20131119144630.GA5780@phenom.dumpdata.com>
	 <528B7C29.3050103@citrix.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-1UGbpH0IFbbenN8AdV26"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-1UGbpH0IFbbenN8AdV26
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar, 2013-11-19 at 14:56 +0000, David Vrabel wrote:
> The relevant bits in dummy_numa_init are in the error path of
> xen_numa_init().
>=20
> I do think this approach (using the provided API to setup the single
> (dummy) node), is preferable to calling dummy_numa_init().
>=20
> If I thought the hypervisor ABI was finalized, I'd be happy with this
> series as-is -- the remaining issues are superficial.
>=20
So, David, in this regard, what do you think about these (and the
following messages in the thread?

http://bugs.xenproject.org/xen/mid/%3C528B7D350200007800104840@nat28.tlf.no=
vell.com%3E
http://bugs.xenproject.org/xen/mid/%3C1384871712.19880.90.camel@Abyss%3E
http://bugs.xenproject.org/xen/mid/%3C528B885702000078001048CF@nat28.tlf.no=
vell.com%3E
http://bugs.xenproject.org/xen/mid/%3C1384875772.15360.6.camel@Solace%3E
http://bugs.xenproject.org/xen/mid/%3C528B97C502000078001049AE@nat28.tlf.no=
vell.com%3E

I think Jan has a point about how we are right now retrieving and
treating the number of vnodes...

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-1UGbpH0IFbbenN8AdV26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKQ3G8ACgkQk4XaBE3IOsQ8wQCePWy0EzU0NerSqcuFZDEFS7i8
vQoAn0oISpLQkXcxrEzk9Q/xFI45BEWk
=f6MP
-----END PGP SIGNATURE-----

--=-1UGbpH0IFbbenN8AdV26--
