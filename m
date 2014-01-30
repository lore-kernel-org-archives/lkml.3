Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaA3B6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 20:58:45 -0500
Received: from ozlabs.org ([203.10.76.45]:42396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3B6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 20:58:43 -0500
Date: Thu, 30 Jan 2014 12:58:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140130125835.5b7809ec9dcaa040b690095f@canb.auug.org.au>
In-Reply-To: <20140130014914.GC9804@tassilo.jf.intel.com>
References: <20140130124201.d24b784b6483a11fe3057bd9@canb.auug.org.au>
	<20140130014914.GC9804@tassilo.jf.intel.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_12_58_35_+1100_ZcbKgVVQk4uI2a+G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_12_58_35_+1100_ZcbKgVVQk4uI2a+G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Wed, 29 Jan 2014 17:49:14 -0800 Andi Kleen <ak@linux.intel.com> wrote:
>
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
>=20
> I don't think the fix is correct, both sysctls need to be kept. They
> do different things.

The tip tree commit 52bf84aa206c ("sched/numa,mm: Remove
p->numa_migrate_deferred") explicitly removed the
numa_balancing_migrate_deferred sysctl.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__30_Jan_2014_12_58_35_+1100_ZcbKgVVQk4uI2a+G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6bHQAAoJEMDTa8Ir7ZwVCl4P/2Ppj1d4Ij3pgeSkjgyC0Vbt
rJqYNdcYT10adT8MloMyXw+Fdm6VRDpvB6qw3sgsFedajj1vJGDo0SlYmKmtD9Ei
cnRUwj6jCpeyekjWyzmsTn4f+2+MV3dKnzIvfgyFWF9QgXiQBheQq0yYCbx2V3k/
CfVtz5S2lK4AI/l2r5y/pcHff46Giw0Mu5OGYUAcfiv4ivbl/2bXdqIKUfOkkmIB
M4lGT83N/NgKNFrwf96vzVTGsuf4lU2ihuFnqaj/P4pmnHPcIRKbGQI7ZXoXGJ/p
SFE9pngasimZ2etqVFLRLWXFwWsXL+BXuxn9tkpwzv1dTNweNxKhaKhTQOsMpGEP
ANw2sAy5BI7MRNAEYEFGjsWFR4pdRK21rD7EiUhRbBaE/n+xOuhBCFlT3/8xpHbn
hssu5JZtMfRbeqH+/YOHpo9OXgrKJA7rPXsj0HC++Zv1Bw6c/VYlgeZRTZBtSynM
XkMXxyV0ZJFC3CKU3tXlMQd++0utWW5C0sPERJZQMVvuTqJfJwai5H1D+6fqLfgD
okv9IlYgkvcWV9dOjIgbEdGZo4FB9rbK9fvOmRLj0seSbdk2/hjuItqacHHnqtO5
O7LiTSPIUWIxkXlb/rV7CInnNMlxb2fNwLgkXWFRF/dC7/bVrpJPYqhkt+zLH9P8
kuAHixkWxXxZ8x3ooM/H
=rJjr
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_12_58_35_+1100_ZcbKgVVQk4uI2a+G--
