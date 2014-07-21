Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaGUFbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:31:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:2219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaGUFbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:31:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="363308614"
Date: Mon, 21 Jul 2014 01:01:05 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
 accelerate S3
Message-ID: <20140721050105.GA21503@gchen.bj.intel.com>
Mail-Followup-To: Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
 <20140718080056.GA2037@gchen.bj.intel.com>
 <53CC7787.2070302@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <53CC7787.2070302@intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 10:14:31AM +0800, Lan Tianyu wrote:
> Date: Mon, 21 Jul 2014 10:14:31 +0800
> From: Lan Tianyu <tianyu.lan@intel.com>
> To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
> Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>  accelerate S3
> User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/201207=
14
>  Thunderbird/14.0
>=20
> On 2014=E5=B9=B407=E6=9C=8818=E6=97=A5 16:00, Chen, Gong wrote:
> > On Fri, Jul 18, 2014 at 01:55:22PM +0800, Lan Tianyu wrote:
> >> Date:	Fri, 18 Jul 2014 13:55:22 +0800
> >> From: Lan Tianyu <tianyu.lan@intel.com>
> >> To: rjw@rjwysocki.net, lenb@kernel.org
> >> Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
> >>  linux-kernel@vger.kernel.org
> >> Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to
> >>  accelerate S3
> >> X-Mailer: git-send-email 1.7.9.5
> >>
> >> NVS region is saved and restored unconditionally for machines without
> >> nvs_nosave quirk during S3. Tested some new machines and the operation
> >> is not necessary. Saving NVS region also affects S2RAM speed. The time=
 of
> >> NVS saving and restoring depends on the size of NVS region and it cons=
umes
> >> 7~10ms normally.
> >>
> >> This patch is to make machines produced from 2012 to now not saving NV=
S region
> >> to accelerate S3.
> >>
> > The year 2012 is a mandatory value in the spec?
> >=20
>=20
> No, spec indicates that this is only required for S4 and commit 2a6b697
> added this behavior because this can fix S3 bug on some machines. But
> this isn't necessary for all machines and waster time for S3. So this
> patch is to add time base quirk to change default behavior for new machin=
es.
>=20
If so, I don't think a hard-coded valud in the kernel is a good idea.
Why not providing a quirk via a command line parameter or module parameter.

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzJ6RAAoJEI01n1+kOSLHA+IP/0GnC/Adl8DP+dp6e6fXruN4
/SfZ9Sz1tJd/kjebpRDl/TmkH3J4wz6y4UGQaLg5T4ZyUkFlKQIXuEQRqSk3QGpu
FzwiisCnRgAGJuhb3veqUAN/hRUDND9GMzUeEPhyBIBrwphLS6u6sajd2iIi31o7
ADXGt35BzRdnwU7EWfoRqFw/Bn6S3gMjXgIJctL+lJU0Be3Q0BNQQpAaIWBOEK0Q
wqmwkkrz9UaqrMmxpTQ0tXUWQnJZv5an+FJM2KkxV5RTXWDZKxAdBPT301MatW3X
pXtp5mJCX7I8WzlqnF/E4r5P7GCd/Kq1535H/opkVOS4I8gLAT8Rg6kvNfcCdlLj
t4LoAuabI+iDPFN/Xh0mPUzOFRxb6l/RVS3y6sNHHewA/QzkeOr0OHJchI/Jqiaz
4joyzYT/KDUJrW5rkANuJc77rjUuQl8+IbxOXhAJPzDHrUGpxdSOJT6bjeHH/IqL
jfLTsJi0KqQvTeIJV4O5IRSYHKi9MmYt5C9c1pec+2Msoc5LUkK83Iemukm+26yd
E3SiPkBtzM3tlteWRAS7qoscMD0aRYnSU/jrXNX/ptD/I8A0RjzQhf/NaV7IF3yX
5PEbBpY0igu/6+iYw8kiFlEFhX7eZIqYmab1mm/r6Pex+/Dly47ak6pZmveoHSyR
abtNS60ayyGnfAky8N35
=JjKO
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
