Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3KSHSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:18:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37219 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab3KSHSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:18:41 -0500
X-IronPort-AV: E=Sophos;i="4.93,727,1378857600"; 
   d="asc'?scan'208";a="75832568"
Message-ID: <1384845515.19880.13.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH RESEND v2 0/2] xen: vnuma introduction for
 pv guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: <xen-devel@lists.xenproject.org>, <akpm@linux-foundation.org>,
        <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>
Date: Tue, 19 Nov 2013 08:18:35 +0100
In-Reply-To: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-Qu9QK2HG8qNqop/ZZEuN"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-Qu9QK2HG8qNqop/ZZEuN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun, 2013-11-18 at 16:58 -0500, Elena Ufimtseva wrote:
> Xen vnuma introduction.
>=20
> The patchset introduces vnuma to paravirtualized Xen guests
> runnning as domU.
> Xen subop hypercall is used to retreive vnuma topology information.
> Bases on the retreived topology from Xen, NUMA number of nodes,
> memory ranges, distance table and cpumask is being set.
> If initialization is incorrect, sets 'dummy' node and unsets
> nodemask. vNUMA topology is constructed by Xen toolstack.
>=20
> Example of vnuma enabled pv domain dmesg:
>=20
Mmm... So, why the resend? When you do things like this, you usually
tell the reason, if only, to let people know what happened and which
series they should actually look at and review. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-Qu9QK2HG8qNqop/ZZEuN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKLEMsACgkQk4XaBE3IOsTJ1ACfV4UEzKHZd4R/S3y0WYlYm4Sr
038An1VzobPKKQVXYbXwdbNwWtH0Xp7/
=4Zwc
-----END PGP SIGNATURE-----

--=-Qu9QK2HG8qNqop/ZZEuN--
