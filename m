Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaEFN0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:26:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:60937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaEFN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:26:53 -0400
Date: Tue, 6 May 2014 15:26:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, umgwanakikbuti@gmail.com,
        Preeti Murthy <preeti.lkml@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506132650.GK11096@twins.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
 <53663565.9080306@redhat.com>
 <5367188C.1060702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3bhLwMadv7h6/J9"
Content-Disposition: inline
In-Reply-To: <5367188C.1060702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3bhLwMadv7h6/J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 10:20:20AM +0530, Preeti U Murthy wrote:
> Don't you think we should go conservative on the value of
> RECLAIM_DISTANCE in arch specific code at-least? On powerpc we set it to
> 10. Besides, the git log does not tell us the basis on which this value
> was set to a default of 30. Maybe this needs re-thought?

See my last email on how all this is entirely pointless :-(

--O3bhLwMadv7h6/J9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaOMaAAoJEHZH4aRLwOS6O7sP/jS/stYp1Ve6N+y2e5gxEtM9
HjfXvLISN4a6pfptFL0oMLjTP7K0ORINoZX29OiaFU7Mie4aygqKkrANNQfIj0jO
ue4CTf+sOdUczEQ8hV9cPDVXSoq6fSF+Ffp8/zqu5bTgXHiBw3UBsxzuJLFfpKKg
GUWlzLixJGCw8rJjvK4qYx6ls06Ek3155AMLsYo8iLhShShgVCdBnkiyWh6fMslh
yr2f4EWzqeREI6+/qon0M6ZAyAPbVg4lSroZRw6RBfAxcFgeFJOx6gNuHRL27Nl2
1Z+pXcJFioigBGQThqXkTgzsP7r7pOllepSTlqxkshE+EArbFHZvbkyPBfCwE+LV
f28tguFlPfKrSrxhcG89DGxAAbzWoRt7lMo4uLmlvxbCEVaxGW7ZFVxVhEBhtbB1
gsKqdVslP2tYcm7tkhf5lezRUkgTaXhS8991zWfDUqh0V4hJJ/BmHdkNESI4CkU8
SzxgQchad3ZrsMJW1sANv18ijwIHGYlo+Fl61JuZ75IfeUTcYodlGXrG+iPoyr05
WfzeeE8ZJWXT7WkdMko/yGhu8KaFnXBdqtsRmwsdgyjw/ikKvoNyq5ydRCJ/QySh
HAGalmaI13ASN8XNE1skPNXAMe6L9te/Fd5EcrygweN5w2a4wlVyICphLXhaFxV2
rGWTeHLOTyWIFzipvr/i
=G7Ed
-----END PGP SIGNATURE-----

--O3bhLwMadv7h6/J9--
