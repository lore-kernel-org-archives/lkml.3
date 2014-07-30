Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaG3MsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:48:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaG3MsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:48:16 -0400
Date: Wed, 30 Jul 2014 14:47:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, "Jo\"rn Engel" <joern@logfs.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [RFC PATCH] mm: Add helpers for locked_vm
Message-ID: <20140730124748.GK19379@twins.programming.kicks-ass.net>
References: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
 <1406716282.9336.16.camel@buesod1.americas.hpqcorp.net>
 <53D8E578.7060303@ozlabs.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+pqIWPix3sfwaup"
Content-Disposition: inline
In-Reply-To: <53D8E578.7060303@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+pqIWPix3sfwaup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 10:30:48PM +1000, Alexey Kardashevskiy wrote:
>=20
> No, this is not my intention here. Here I only want to increment the coun=
ter.

Full and hard nack on that. It should always be tied to actual pages, we
should not detach this and make it 'a number'.



--H+pqIWPix3sfwaup
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2OlnAAoJEHZH4aRLwOS6nFUP/2U1vEbRt92TDziwqtL2/HBZ
Nm+eMGwPbUoDQOF/J+aXiD3QDX+7nsyK09bHShwKSv6GidCopO14prSIlPsT0LyN
NYleSCoIbKrKXttHpxGFftUJNaw6Cos/IUSrDn+nRXdLSLpnUBMmciVKlJ3ebaVu
PO2ieMWEW8hmHKINSxpVS5IMLf4AmSW3+pO93J+0lIGcLb/WMwS1sOqmuIyxM1Fm
LqtsQax5uJZHHdbl3q38/Eq3B0FV3k6VUwRbBYtedW8uUjqe6fhRXLQNHZRcGTa5
vr6EYAi7hFCKarodaxmujJNl/Pt17Bkes98UmZsod341wjhqedWs8kPNZOvS65dB
jHmaa/x7oXS8B0UyNQdAtsqTAUYezF/sXrAsUYh8XARZvhmVwcaeATtSqXT4Y1SM
IgxPiSel9YcQivUTs/jbn0qhzFhCALjC8yuxvMBxdPdVOWyQ9+npomYJayTjIHQX
6zN0KnhcvpS9znk9maphhrx0LGE7tNfIwIcVUvb91joNsgD9hhmS2AIAiLln3g/1
LoHz9UFLPpTqc0dFbOV0Ipm2gHRseSImcCPJ96bxMHgQrf6cCMzbHoImqtiXlJ1Z
kBTHKWUPa4wxbIyL3D8Xj3E6nsIMgL9rixTFphRrbpf6OHq768yGhv+vSnwPPE0W
OCfkD5HyZNCpquqj1CkO
=+FSo
-----END PGP SIGNATURE-----

--H+pqIWPix3sfwaup--
