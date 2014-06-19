Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbaFSSu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:50:57 -0400
Received: from sauhun.de ([89.238.76.85]:37053 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbaFSSu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:50:56 -0400
Date: Thu, 19 Jun 2014 20:50:53 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] Remove devm_request_and_ioremap()
Message-ID: <20140619185053.GC2646@katana>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 19, 2014 at 08:48:58PM +0200, Wolfram Sang wrote:
> Pretty much a year ago, Tushar cleaned up a lot of deprecated uses of
> devm_request_and_ioremap, yet some remains are still left. Remove the last two
> users, and let the function rest in peace. I'd suggest that this series is
> picked up as a whole to have that case finally closed. Greg? Are you interested
> in picking it up?

Note to self: Add Greg to CC list when asking him...


--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTozENAAoJEBQN5MwUoCm25XoP/A+YIutB3lZ+ko3cxRWjN+hr
WrMm6nIZqRJyHdLBO/dBKb6cYyXvCleahfqd/KW1jeHUSmYAVi0LLvZb2sG3C2NP
elq9FnyrhZK0oTuv4WXyXHnVXzTxmwqwxM56onulqn/JdoTf1GKqwdIgYZjm3Cl0
g/nCGjkFbZ9SewDfW7NCJWfVuMb1uTjDEKJ0gMMDEoM+CnLkOkILcdL0ttgyNfCS
XTLRYXeCtFLUgbLa9RTE9yze4r8AEDKtHi11LJtxYEb+PNZtOvZ9IT0pkTGFO1bf
a+qaMShnSPb/mlY4w6xAfQKlD79e4jGuU4HjqM/aph62+XW5MCPZuHQCO5lypA1i
L3bGrqaSWEWin4WgOKXi/B83iQ1DmKkxHKzbmJ3glhMp/Attr7isFju0K3nH+qac
QgAG24VrA/B8ybqk24skTiaRMXMdlTY+AwpZvLi1sOjAtiDvU82vSwMgcM4HUaNs
f2jomHETCpNw8/BthW3VRoNd/N8hSjgA+Dn8KFpNWYkEjq+tFS2eJBk6PuxbRUqC
DMpnW2WYoP6oEMQEBmJl/3GCMuOZxyku9fOJhiYIy5F478CLxXA30fdwga/pdDMz
YAT4oMOq/kqnGmM4wL9e08bvf/ZOHYjp3MAnazMOCdykCLY7iyXvjgNseq7SXd8p
jNUfHT7mpkmqtXXji8L2
=1oNC
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
