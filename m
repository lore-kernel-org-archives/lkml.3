Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3LDHz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:55:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:34159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab3LDHzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:55:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,822,1378882800"; 
   d="asc'?scan'208";a="393934980"
Date: Wed, 4 Dec 2013 02:38:24 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131204073824.GA22134@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
 <20131130111214.GB4323@pd.tnic>
 <20131203022330.GA25136@gchen.bj.intel.com>
 <20131203170150.GA5369@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20131203170150.GA5369@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 06:01:50PM +0100, Borislav Petkov wrote:
> Date: Tue, 3 Dec 2013 18:01:50 +0100
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
>  Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, "=
H.
>  Peter Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC
>  <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register fail=
ure
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> Can you please fix your
>=20
> Mail-Followup-To:
>=20
> header? It is impossible to reply to your emails without fiddling with
> the To: and Cc: by hand which gets very annoying over time.

I add some configs in my muttrc. Hope it works.

>=20
> On Mon, Dec 02, 2013 at 09:23:30PM -0500, Chen, Gong wrote:
> > I have some concerns about it. if device_register is failed, it will
> > backtraces all kinds of conditions automatically, including put_device
> > definately. So do we really need an extra put_device when it returns
> > failure?
>=20
> Do you mean the "done:" label in device_add() which does put_device()
> and which gets called by device_register()?
>=20

Not only. I noticed that another put_device under label "Error:".

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSntvwAAoJEI01n1+kOSLHF30QAIj+/G7TJb66n5+puyZWFQW7
0AsZFTC9T6GXGO+cerRp3CTH4jE2eBlF6wZei7bg3p1PSNdE1r7LGYMnFyKsityw
krkLyFWT7n/Nmd+oqUgTBo9WzgEqZ2nPlOi6Ht8vv0IOIn6nQ1Lye4DbEIa/6rm2
/ZrxQm1ueQ2dWYHzx6M3i544UNKQc4y5zjCXyVyhWHYU1YN3vFvDYbieMhrmFMIA
W7Qjc6KtheVehsz6X3HthX6yTrLNAN9swibg3fDZ3gmxissvWqYMopDzaxa3ZI7z
nptdlzwUqmyImEJ91RcFzKJ3a3s1asiq6uvhnMmvlz2WyEvwN1TVqD78ZI4ORNSE
LrsafFk1WnCslv3GEt3l59Q2meTTWSzOU2b1tzXCCvQMrxNQsJEL2Qc3GEE96LHj
64Hj0pWM4KySNtdc1tStCkupA3VXHEyLRPY8vuK3hDWpTDw4EeIYWBAh2KJHT8hP
h5aCCN6zh6PzdJiEmZLlgtddJF06YSO6lsMpZMDXSWR/jpFuC/MCGocU+MLXVFvG
Pr83pNnnHSbFF+jEIem1pTdU9fvTXi9UQWgjG49q67yMURKKHYr3/MXDvLB8AJvn
JPuDInir7FKJjczb1LiwHl6RT4J318u3J5YOJJAIzbMT2wwZ8XkH6sC1GG0g/eDS
KxLFgIYisIIy4MzV+bjp
=KXJf
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
