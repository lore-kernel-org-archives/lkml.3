Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3CUDwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:52:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40765 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3CUDwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:52:00 -0400
Date: Thu, 21 Mar 2013 14:51:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: linux-next: Tree for Mar 20 (vmcore)
Message-Id: <20130321145154.78c7c46b69894c6d15aeb4da@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1303201945580.29880@chino.kir.corp.google.com>
References: <20130320160536.54e62fc11a3651494b710e3b@canb.auug.org.au>
	<5149E813.8060307@infradead.org>
	<alpine.DEB.2.02.1303201153330.17761@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1303201709440.23363@chino.kir.corp.google.com>
	<20130321132012.e6f9a10287fb171dcd05c62d@canb.auug.org.au>
	<alpine.DEB.2.02.1303201945580.29880@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_14_51_54_+1100_GllQRO_d+oZbhF3a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_14_51_54_+1100_GllQRO_d+oZbhF3a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 20 Mar 2013 19:49:09 -0700 (PDT) David Rientjes <rientjes@google.co=
m> wrote:
>
> On Thu, 21 Mar 2013, Stephen Rothwell wrote:
>=20
> > What exactly are "these patches" so that I can remove them from my copy
> > of the mmotm tree (assuming that Andrew does not get a new mmotm releas=
ed
> > in the next hour or so).
> >=20
>=20
> [nacked] vmcore-reference-e_phoff-member-explicitly-to-get-position-of-pr=
ogram-header-table.patch
> [nacked] vmcore-clean-up-by-removing-unnecessary-variable.patch
> [nacked] vmcore-rearrange-program-headers-without-assuming-consequtive-pt=
_note-entries.patch
> [nacked] vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-=
data-size.patch
> [nacked] vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.pa=
tch
> [nacked] vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch
> [nacked] vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-=
2nd-kernel.patch
> [nacked] vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-ker=
nel.patch
> [nacked] vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-ker=
nel.patch
> [nacked] vmcore-clean-up-read_vmcore.patch
> [nacked] vmcore-read-buffers-for-vmcore-objects-copied-from-old-memory.pa=
tch
> [nacked] vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundar=
y.patch
> [nacked] kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
> [nacked] kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
> [nacked] elf-introduce-nt_vmcore_pad-type.patch
> [nacked] kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boun=
dary.patch
> [nacked] vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-n=
ote-buffer.patch
> [nacked] vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-r=
equirement.patch
> [nacked] vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.pa=
tch
> [nacked] vmcore-count-holes-generated-by-round-up-operation-for-vmcore-si=
ze.patch
> [nacked] vmcore-introduce-mmap_vmcore.patch

Thanks.  I have removed these from my copy so that even if Andrew doesn't
get done in time, they will not be in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_14_51_54_+1100_GllQRO_d+oZbhF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSoPaAAoJEECxmPOUX5FEsFMP/1XUB7sSdCsE51mtDMAlqbS7
630meZOrgpQk63NtKgSXim3h2BWhoCCIbOl5S9IsqjwBxqwfZimXvFD/f7+DrLgx
gMf3YkwalaWoENW6/HIpDLuGYdY/wRj9IKAjOBm/BmAiN3eTqV7zKFXCWFd33eB3
ESWcSY1n1cthhiqF0k0gB35JhKlGCUdE3cFwzwugnwrPZrVJcJNEpCaLxOTTS79X
AstiGNLk9wXWbpA/FgwlmJWs10+VqkiiwcuAoKXFgUpfbxJEIonjlu0Ph4cglKhe
WpGQtFu53d9EEnwQHReTb4D45ulEt3aYR8PqBwO+hxlIsTd+BgrzUZd6YnuQnp+Q
dTE/6E3zA7qH+w0K+ARbEHVd5tDapitawjg/lZV2bOdC/tZA53K9apb1NRSw6BxK
cz0cat3dW+BgB0LlqaQl0GDwGRFIft+ktJNPmW5/hjD8H/eA5laJ+36PYygBW52b
oAdzR/CNkzEK5CpFkPb486zOgj6fs5eA1G2dbGU4Y4JK32VEI8OsnT91+B0uRzAW
sDHQWSHrzsLWTBh6UP7az1FeeB+H67/IDCCWua61abv0ZcXTlTIbjZFb2yphceOA
g1XduyaHp3daq5nKBKNGiQcaJqKWMNzTdJSmEbRMWyJw/v5BjN5tVgGvTzizhfoj
J1NcF9pH0lVHhFB8uNKR
=mFVX
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_14_51_54_+1100_GllQRO_d+oZbhF3a--
