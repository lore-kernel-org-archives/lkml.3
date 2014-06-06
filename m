Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaFFGpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:45:47 -0400
Received: from ozlabs.org ([103.22.144.67]:49191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaFFGpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:45:46 -0400
Date: Fri, 6 Jun 2014 16:45:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20140606164543.6c5bbe67@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gEOv7KSFIxcAdbyY343hlAJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gEOv7KSFIxcAdbyY343hlAJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc allyesco=
nfig)
failed like this:


drivers/net/ethernet/amd/xgbe/xgbe-dev.c:119:25: fatal error: asm/cputype.h=
: No such file or directory
 #include <asm/cputype.h>
                         ^

Caused by commit c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver=
").

I reverted commit 54a4ca8e3730 ("Merge branch 'amd-xgbe'") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/gEOv7KSFIxcAdbyY343hlAJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTkWOXAAoJEMDTa8Ir7ZwV0z4P/itAG4q6wAp/nEHe1J9qfwVK
/qfGRKwIK3saKbLlUdwCFXz3LsOvqnnxH7qT6apaV9ZGNUfFibwptgqoH4zAv8Mx
TP/3N5n5Y8FBFNUWHCV53L+J5m1lLMNFv7gCj/Y6p1Pjr/U1Aa++CUvkva9jRE/n
6NmqjCwQy7N/GNskvZt+bkDNYjQLyeQUNLMlBxcU1w9lRSXRhruEuKlS3Ry+buum
5SoR1G9Mp5etLk0dMh2uuT9UPLgMHRgHAzSnjHUkjh5hP6JuqMAW4oEFFYfS7LYT
PxZjdTlgjLqxl7CJx+m5nScrYB7uPuCbQBnhuPGVHfLmIydaObFGWjEwHFGsItmh
uUgtMRtUxjz352eke/FWsAuYzKI6mmBkE70c/qFUwFrIbnxK3KkTnDdOUaVjjxPu
T2Q8w0HprfQocvInCT6WUrB9ivqWpPLDsaFC+MxoOqUcBjus6aBwHUCrvI/2NJsA
y2Ci8BRXXQBcOIqE/21eMN/Tg6vimgBVK3VnKxYuTNtSIaPoiJSvp7SS/4ZnXeBS
dc3J0/yoThmHRjujje/H5YxQqK+aGEae4pX0X9yp2MFEZgTAJ0cR5I82vFlSYlWY
0ZiHYfyEG8qy5iN09+qXrMEvSx3N9QIcgDcV0nIScB/f4j/RxCf/oegIh7sthFHJ
0wZUt6ay1qYVzUS7RNLF
=CSFu
-----END PGP SIGNATURE-----

--Sig_/gEOv7KSFIxcAdbyY343hlAJ--
