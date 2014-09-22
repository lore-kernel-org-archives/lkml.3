Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaIVUKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:10:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:61520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbaIVUKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="asc'?scan'208";a="606760430"
Message-ID: <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 13:09:33 -0700
In-Reply-To: <20140922195737.GE4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140922153355.GB4510@pd.tnic>
	 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
	 <20140922184049.GB4709@pd.tnic>
	 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
	 <20140922192152.GD4709@pd.tnic>
	 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
	 <20140922195737.GE4709@pd.tnic>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UCeURwFdca7VR5mDEoka"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UCeURwFdca7VR5mDEoka
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-22 at 21:57 +0200, Borislav Petkov wrote:
> On Mon, Sep 22, 2014 at 12:44:17PM -0700, Jeff Kirsher wrote:
> > Not sure you showed us, since that is how everyone has had to do to
> > actual find W=3D builds useful.  Just because that is how we HAVE to
> do it
> > now, does not make it the best way.  Here is a thought, we don't we
> fix
> > the potential issues, so that W=3D builds do not generate over 100,000
> > errors/warnings.
> >=20
> > Mark did this approach because it would either spur the conversation
> > that this is a good idea OR let's fix the root problem.  Instead it
> > sounds like your response is "life sucks, get over it" and put your
> head
> > back in the sand to ignore the problem.
>=20
> Hey hey, relax a little - no need to get offensive all of a sudden.

Sorry I am very frustrated at your response.
>=20
> Having to grep through a log file full of gcc warnings is a much
> better
> thing to do IMNSVHO than adding code to the kernel just to shut up the
> compiler. We had huge discussions even about something as silly as
> uninitialized_var() which was supposed to shut up the compiler but
> ended
> up actively causing bugs.

I am not saying that the proposed added MACRO is the best solution to
this issue.  Several other maintainers have actually responded in a
similar manner to the macros being added and came back that the better
solution would be to fix the code so that the warnings do not occur in
the first place.

So I guess I was hoping for more of the response, that "let's fix this
the code so that the warnings do not appear in the first place".

I agree with you completely that I do not like the idea of the MACROS
being added to silence these warnings.  I just disagree that not doing
anything to fix the warnings is far worse.

Why grep through 100,000 warnings, when we should be fixing the code to
prevent 100,000 warnings.  Not saying that the MACRO is the best
solution, it is just a solution, in hopes that it spurs discussions like
this on how to properly fix the warnings.  Not a discussion on how to
grep through the warnings and do nothing.

>=20
> Now, you're arguing for adding obscure macros to shut up warnings
> which
> are disabled in the first place because you don't want to grep through
> log files.
>=20
> If you can't see the absurdity of your proposal then maybe we should
> agree to disagree and declare this back-and-forth for having run its
> course. In any case, you get my NAK for it.



--=-UCeURwFdca7VR5mDEoka
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUIIH9AAoJEOVv75VaS+3OOm8P/jWLkJFm1OO5uGtmfrq/OTXE
HPxTs5jTgSV7SOqQgAgCknVQisleWguiJDEjN+O1nQQ3OVl6WbAD4OQnJa9Z0mcO
6YK/7J34pHVXVBx1lEekY6Sg1GhI+IVwiH7ximLFYdHjMAF/0T96qrOVMxczpsv7
HIiJmuF7w9am/8KVvQy6kVFsLrJc+SN1B/Z1LGBObPUamBNd5BU/hcbHbC14WBwr
J1ce7hi3x9lojb9PUbf9Y2A/z4K97CSDLH4vUroUEQwHmlq8aYnu/17U9gQgSYmD
1PrYiRzJbYILdaxYghDbbZhSXKE08uwY/NSVPH84g+I1Ty2r/KTIMfpJJmSvuCb2
Uh4huaA9LtHKmKQyg6tPcI/AYOGTPwq+kCE/vWAyRZ3x9ax2rQBu+FIVKaXk3UdP
cWRnCJIXpfnEhIpygUEmd9OipIUpMxxH9PpaHek7F89NKZoMGyTp6roRkligryde
m7s7/ORHWYweEqUiBVfBFE23/xmBF9PMnblDlZT5u0SpeF1Ro5/HXw28QL8382Kv
glT3Yd4zMsVN2Wa9S/wvRVep5Pby8mGB43X9aXcb+UzoYMnsePH9My/4JyhNOEzM
ttmSglA9rluOBytzlQkMaY4P21MGvZBipGfd65TTMw5Q40a0HA5vBsbgDZ5sj/yW
8rRWAtVdKxs0kctxzQzx
=Jwrn
-----END PGP SIGNATURE-----

--=-UCeURwFdca7VR5mDEoka--

