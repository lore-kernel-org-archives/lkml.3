Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3LRCuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:50:14 -0500
Received: from ozlabs.org ([203.10.76.45]:37136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3LRCuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:50:13 -0500
Date: Wed, 18 Dec 2013 13:50:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20131218135005.188890e525e7722cf9f528ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_13_50_05_+1100_79cpD+cyJiW+gaIo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_13_50_05_+1100_79cpD+cyJiW+gaIo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_pm.c between commit fec8cba306f9 ("drm/i915:
use crtc_htotal in watermark calculations to match fastboot v2") from
Linus' tree and commit 96f90c5421aa ("drm/i915: Move ILK/SNB/IVB over to
the HSW WM code") from the drm-intel tree.

I fixed it up (I just removed the code removed by the drm-intel tree
patch) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__18_Dec_2013_13_50_05_+1100_79cpD+cyJiW+gaIo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsQ1hAAoJEMDTa8Ir7ZwVfHoP/RbQ+BYot/o34XL+Wkf+qlDF
opnqdcQK8kSh5WYLNC+3GUPVIlpVABhrYrVCRD5jRZfYm+05hdN26vMY0TyKGx3u
HlarEIY7SvM4b4MRVapmZ1FlvKRtnUP7yJxgIgxHnCbIOfKXKY/D9SzGij3U6lLJ
m4MHEvHSFgutH2YZvSjAq1uj5gY9GNZVNosBUr3Ol+tauoVvYtSLoUbdCUdAnCFT
yjF7md3l6x7ChTsueHCWf5IzUThi1XQH38rBO8ZMncZUOUZZZvLK1ZGmBoDgZoA6
KPLolrppeasSvF1UKns1glI+v5Cq1lkq+OMYVfJYmR9F9s7JBubKUDS5OpqBPFF1
rb6eBXQx76aVrMS5h6z9TZl1DxkmgFQ2+bBKdt22UiSu0eXN6+t+WxNqmonMNCt0
uLlx3RskTkxTJxwVDBU/XhlapzbAnKWe0SQMZJ+hrbngg37WU8+sbov85bH9XiKq
I6Ekal126spCKJEUTYE52Kn4RY0SOXRsby5iBz23FG1TAzsdvhhcmIItdNu1sAMG
L7j+b2e6g2Eqr/6xkg9wdY6wbT7NwN9JpnirzguKKqNZWkEDzuZosV66GCX5WvWX
MXOjCiI9X4l7+FLbudvbeGZCDnsPFqt5X44i9z5lDh6HASxjXy9n3Z9LrG+rjM2L
hB/hg1YMBLkrqS/fhWe5
=XuMk
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_13_50_05_+1100_79cpD+cyJiW+gaIo--
