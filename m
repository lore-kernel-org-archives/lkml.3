Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaKMXpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:45:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:16978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934320AbaKMXpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:45:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,381,1413270000"; 
   d="asc'?scan'208";a="631676187"
Message-ID: <1415922083.2454.33.camel@jtkirshe-mobl>
Subject: Re: [PATCHv2 net 1/2] fm10k: Check tunnel header length in encap
 offload
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: netdev@vger.kernel.org, matthew.vick@intel.com, linux.nics@intel.com,
        therbert@google.com, gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 15:41:23 -0800
In-Reply-To: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GuZpi5xbYnHsqPXICOTQ"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GuZpi5xbYnHsqPXICOTQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-13 at 15:36 -0800, Joe Stringer wrote:
> fm10k supports up to 184 bytes of inner+outer headers. Add an initial
> check to fail encap offload if these are too large.
>=20
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> Matthew, I didn't see the equivalent patch on netdev so I went ahead
> and
> created it. If I've missed this somewhere, then please disregard.
>=20
> v2: First post.
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Thanks Joe, I will add your patch to my queue.

--=-GuZpi5xbYnHsqPXICOTQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUZUGjAAoJEOVv75VaS+3OAFgQAJ6daVYXSbd2TWSe+vyooSPg
vT0DbbSpA7FJr6WboB5kVCNiythgsT6A0jSA83i/Ppd8idHdxgT9mb9HFoRKqikb
mW48LNjDfSxcMc2HVQRskJSOKPnhkSxe3rMN6Fdur6lNB8xrKDq7dkYMrpsIL6FR
dTqoSW8XfBefg97tiVzCZdyUX4+PrHPBbTYEKQHon3n8rrYtv9eL6kcEBhrFPli+
XH61dtsjKRxUZ44Fl0HPs224d5jItJcAOTwiGgrKyTNw1Wq3KMFLtHBirEZKlSdN
ijS8C7XP7ygG+Qbu9ixT6rVzolKmFB68xrypv2+hmOEr0u+CJOALQq530zTf/QBl
1arcPzC3kciYvZm2OOeO6QS6NaB4zJZY8YN3BNLkPTLsS5iTq+AmspMeFNxpi0VY
ew4vydmhHi5ThRZvQzv4MvOQbzS8yosUVniImGLgCPXykldEucEdpyaLgderH8zF
zcTKbhuhPF1fZ6pjEWGQzwLQnUfyhe4YIU9JkLdPYGzHxnxmN7ov4yMEfs58raXa
PPAR7O+gBiB4inNTIZGzqSZsTHZGvNTG+2qNW2VR7T9MI2gIcpZcLfEK4tTY7tnn
f5HbeB7shARjzhMJVig2QEfZ75xrSuq5kO2MkdxFhcemIi+iaTkqqnYFXo/aVNeC
fBpo8Iwytsh75nS8fR4M
=l1Y5
-----END PGP SIGNATURE-----

--=-GuZpi5xbYnHsqPXICOTQ--

