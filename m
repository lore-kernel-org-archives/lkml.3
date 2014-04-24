Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDXFig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:38:36 -0400
Received: from ozlabs.org ([103.22.144.67]:45950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaDXFib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:38:31 -0400
Date: Thu, 24 Apr 2014 15:38:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20140424153824.c65cc3202124674aad968113@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Apr_2014_15_38_24_+1000_X=eBrcYh/.jcGWQZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2014_15_38_24_+1000_X=eBrcYh/.jcGWQZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memory.c between commit 1b17844b29ae ("mm: make fixup_user_fault()
check the vma access rights too") from Linus' tree and commit
0d84be787c23 ("mm: move get_user_pages()-related code to separate file")
from the akpm-current tree.

I fixed it up (I applied Linus' patch to the new file) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Apr_2014_15_38_24_+1000_X=eBrcYh/.jcGWQZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTWKNVAAoJEMDTa8Ir7ZwVOg0QAIj1Wam/puhb6TMo2rFoVsPy
fSnBmGq/dUkjknrijH0+8bYXpOcfbAvHH0EIPIYUlW6pdqfgDYPLgi1QNtyDin6S
zTtlWyIjA+KBcdzOWpis9/+x/sCtLeu/dCstVhJ417VVvNzfOECfbTMnYj1s5EeL
nCPP7Kv1AUKYf2r8UW/3lXEhBOlIux6BiPOUEDoFWtNkG+VVSWFuaQka65/oNx2Q
1T7ZG5MyESnJkV1qHK+5DioFyvqcvpK2amMvx2Xvz9au757kjZ2DH9eu1JggQ4FU
ZIMWEaEbXW/ct03Ad3aOdfkeEmS6ExW8LzLrmJevuIAC1qFlO3EAMcGZDt+IaEvF
Z7WGdO3JgJOuWYuOv8cnk/AHQ8FAnxtZ0hrhzriJF8lB1uEp+RVPKFR5VgblAsNz
WDG4KTl/L++XHM6ITVEkj/a16pgO2i0qC0wqcONfBiEzTVLzQrrz7MkZeU8wVYyI
a6xnVJSLgjtqwp5IqWqlJ55T5/W7a4IH79b6P1cm4MuU1nrGPkFV4gEhL/VerJlh
eZblDI0APQH0FGM4lDX4MORhv17oJ65U7YFbn4S/00BVuc5ejC7hbVMC3A7DGQpS
GWPlLnNa2mkyZAT0sbTG2AOU6S9hvrQGq+RTJAW+GQ3AIydznI+qBv5QcR8jxvjv
FVTFaAuZ1I4QK3DSWd1E
=ar3d
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2014_15_38_24_+1000_X=eBrcYh/.jcGWQZ--
