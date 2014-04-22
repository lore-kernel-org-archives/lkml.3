Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaDVBFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:05:12 -0400
Received: from pide.tip.net.au ([101.0.96.218]:50572 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaDVBFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:05:08 -0400
Date: Tue, 22 Apr 2014 11:04:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with Linus' and te ext4
 trees
Message-Id: <20140422110459.ab3af554dd61297c61a568c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_04_59_+1000_o.iz7QBTAuWdFk+w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_04_59_+1000_o.iz7QBTAuWdFk+w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/extents.c between rebased versions of commits from Linus' and the
ext4 trees and the same commits from the vfs tree.

I fixed it up (I just used the version from Linus' and the ext4 trees)
and can carry the fix as necessary (no action is required).

Al, this is why I asked you about checking with Ted about his tree being
rebased after you merged it into yours ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_04_59_+1000_o.iz7QBTAuWdFk+w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcBBAAoJEMDTa8Ir7ZwVbzYP/ApoRPQQKJ2ImGXNWtfNcptK
mocUZg7ksjqPoUWtYMW6XBVO0Yqg8vDNwVPDMmNOfLENPuT4Two0gtMwmeUny93P
k8UwPRJDf7l3XTz0t+jyCZLKVKsjjw+q+3c2vIroTpZ3ufnH5OSbzIjNtmdXX4Iv
PwROWXqwwuKMs31U9o63/SsJs6QcWlWU8Z3iY4lLBTjRaSBtaqrDgbFOZ7omJTm+
w7zBVdYQl8P3JgRXpLOjdhKNss/8uugZ3XRzW7ye73giHt8d2Q0k/BHMWeLDdj9t
JJC1Tz+rL6Pchg1s2mQXAcwCiMWpVDD/smJbjBNViA71YFLw7k9qtEsQwOU3Ess/
3/yBN421uWYeg5o8TD4lrhUhC51pLs4zybdAHELQnnV+IPqTRhXBbs3cpJ/DL7Ig
44XNubrOjiSuJvNr2uF4Gwf7ICO8LodYXGV3ZQPmqo6EhRUPeJxQWCsCfBydg0ks
EJbJo9h5KGS6n74NC9mxL/tU2BhRv3wda1krFl6ikzLTU04HWaXSpEoiILHtUdO0
rnMHHY47RxhmWfkYcU8Hz0z1W0iGTodtim017BnGG+xk2BffoP+kWIcSuYlAo/0S
HAtMFFxM4ZyR/ER71otwePscXCpmWlviDHxF2ByRzWIW0GViK7VygYpVFO5Fc6ZM
AXI3bxukOtO3yF3lZsyF
=aUFM
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_04_59_+1000_o.iz7QBTAuWdFk+w--
