Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161302Ab3FUAJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:09:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58443 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161284Ab3FUAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:09:38 -0400
Date: Fri, 21 Jun 2013 10:09:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: just chaeking correctness of the infiniband tree
Message-Id: <20130621100928.36a0ccf45e310f02a4dff53a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_10_09_28_+1000_=zBCq/iQoRxiHrq8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_10_09_28_+1000_=zBCq/iQoRxiHrq8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I noticed that the infiniband tree is now based on the net-next tree.  I
assume that is deliberate?  I do have to question how much testing that
tree has had since it is now based on a tree that Dave only released in
the last 24 hours ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Jun_2013_10_09_28_+1000_=zBCq/iQoRxiHrq8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw5m8AAoJEECxmPOUX5FE8kQQAKVdpztXG+0cUurzFcDmV3Aw
yZGkP22IurHYaKLsp/aIFJqmS4H8AmZP0wff/5w+EKj7fLVdjJyhCLuJCXZkOnGy
GF2aHd+L29XDUugs8bOlw7Xgr0jN33/mZ9mVUaLk88zqCrePcFZiKXJ4qYud6Tjg
MY/tO/yIQEzCwbAL+WBMliQFZlQOAzLmx9mZIwwvN8GiR4SUydFs0eFNpQTPRw69
wHQHBaLbymqkH0vkWF4hUq5kpJJ3J1Sp676a0Y56BMAx667hAncsdhsXBC8jKyM2
IlusUX/GXbW7QCCv7pdO+Ve9KX8b2OcMIlnF95gCnMRd+bgqy1Xwr/ejzBqEZtts
OUSf+KZrmTfb1uXYH65u8BYkBtN5SJWzvdZ7qW1o8eSK41v2AaHi7GqMjDi+zYLX
eI99k2MsuKMLb94zJeCAU2M4mHVWgxZuYkz0QaewMlldVi6ZnKxQwv8+HutI334Y
nBRoOWDFzyIuYAx09auaxAzaS2VrO1j1xKKzhqIvGbpXCiTLY0kLieNJl4eT1nUl
ZCOpKC2PXS6q3SviK3EeWUlbbtlSWhYyEzXb2LaaHcm2Oq3dwWmcLYEobqqH7YB1
VeubJh61HvmoIQDygFFFBvOLAaQApUnSd4VJj24p1Tez55w7HVusvZKGv77f/lqS
rPHYVp7oOXR+/A3MLOxS
=T063
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_10_09_28_+1000_=zBCq/iQoRxiHrq8--
