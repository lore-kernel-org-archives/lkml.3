Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBNE0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:26:06 -0500
Received: from ozlabs.org ([203.10.76.45]:43523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaBNE0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:26:04 -0500
Date: Fri, 14 Feb 2014 15:25:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: linux-next: manual merge of the akpm-current tree with the cgroup
 tree
Message-Id: <20140214152557.cf6e5b5b0961dc47f800fe4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_15_25_57_+1100_L.Zeo8H1L.qERp1c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_15_25_57_+1100_L.Zeo8H1L.qERp1c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/cpuset.c between commit d66393e54e0a ("cpuset: use
css_task_iter_start/next/end() instead of css_scan_tasks()") from the
cgroup tree and commit a82211b06d6e ("cpusets: allocate heap only when
required") from the akpm-current tree.

I fixed it up (the former removed the need for the heap, so I effectively
remove the latter) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Feb_2014_15_25_57_+1100_L.Zeo8H1L.qERp1c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/ZrZAAoJEMDTa8Ir7ZwVKUIP/16S636I2rElzD4w3VdWrKHu
1rfsN6mH/UQw9xbaDyVLqORc/RMruisG6ZrGFIXIxQrhR3TgCgWRVqExpJCoIhkO
N4ujdZC5cPu27wRHsexUg8z/78KwKfjpvmOSAsKXV+oudMZMXslMc+A+AdcjVy4b
E2VQhQImo2RBtvkxDm3l4oIT5JLDvjtqh+L+lG7zsH1l5ii6iCd/84JCisdYNYAU
lrRXTpQEy5+dZ7J1mXlpwakind64Ra/34Zc72Odl0v6PIY+tu8Ym5uO/LKp1bZKA
ctQ2lza6MJ8ISnYYmFXXumwJiCVGkqTY0QVDkTvDmsgdAUxKBVm+NfZn0uFFk7S3
ZQEzzRQktpMuN1FBriZzbrEhUgqvQlfbtAoAQ9LE7qNpkDGSH7KsZMZ1NUxphCCV
uUvsP9eR11OnEmnF0ran6uJ0Jnk2mR+JpSQRmOtQRHRtk9VSkf20WKkvZi9crI1a
dHUU/amYHYIV+wyhLlu4HJnVH4dDge3geAwxQmVM4Cu6RMLi5oYvw8yVJ4bgeeTc
w+Fm+vOuJZjOT/SyajcLSXyRFMJhPRd1+oT/trvdt5u8ViZTGb+AuJwV3xUSkG44
rTm5azMRrdzYyb0urw+oujDKzNxVF1qWu7moiH9ebtDA9lNmAjXpAIZkyoRGPhgQ
SvjTWbIDNyJgBCV4CBml
=VEaB
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_15_25_57_+1100_L.Zeo8H1L.qERp1c--
