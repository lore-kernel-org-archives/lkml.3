Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3CUXXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:23:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56732 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3CUXXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:23:11 -0400
Date: Fri, 22 Mar 2013 10:22:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
Message-Id: <20130322102257.89d3fd7c109c32faac4dcc7d@canb.auug.org.au>
In-Reply-To: <1363145021-14339-1-git-send-email-s-anna@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_10_22_57_+1100_/0bWcySyk5bUbMaN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_10_22_57_+1100_/0bWcySyk5bUbMaN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Suman,

On Tue, 12 Mar 2013 22:23:41 -0500 Suman Anna <s-anna@ti.com> wrote:
>
> Stephen,
> I have hosted the series at [3]. Can you pull this into linux-next
> sometime next week?

> [3] https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox

Please quote git URLs ... I guessed you meant
git://github.com/sumananna/mailbox.git, branch dbx500-prcmu-mailbox ?

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__22_Mar_2013_10_22_57_+1100_/0bWcySyk5bUbMaN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS5ZRAAoJEECxmPOUX5FEPuEQAIfyJplYR8RHGIPdswmBRuEq
3MailOUyRlPhO9wqJuXKHUhBsVaFwJthQWdvmcIXaeBTAH/14Kg/cZxabhzttlbW
2AsvOAAwTPCe83wE/leBXvVvzivqiS2gUfdIzPbTrH2Sow33tFfx+FCdj3VJbmIM
pQYa/1NxjtH+ti6+d1BxSp3NpNeUM8bYWakijvJ3SaqDdyRF9J6ozdvJpU0MNayt
ma0A0I9Ns2yNI91VDXFf/IceiYG2yWu92bs+g6vK7f2KHwFVnJzasoKyn7Vm0FJ7
dmxvdyCeVqhe71Bu+eCqqDeMrw9jg79A9cUb008lWWMUQGykuOVuAYpAKhvfT7eK
wr8w1rSBrdtuWRg0x0IL84gFDvQ9JNCk0QMUIr4brxDAsYbMNKPnwue97F8Eecvn
hamoTDLAv+aYqq+3jitt/DzJEdzmqxu+DH3LetaQ60SO1zVP0WwKCxYvG1bPUdNJ
K2vswNavtDJuMfoW8XBGRBVyCDmZcEX6FfBWeZ0azu2IeljY1AI0fRJoI5uOSFpj
Iu+ZiW88Iypv+wjj5JChnUz/QGFUe1TAqPXOof32VntO5YuIenuPtz9DyKE3SX0Y
zvGkhTNtZxKGSylLmGxoY8/o8sMM56sojXuO6TA1XHmZh97LvXt1Bfsz5j8oxhs8
19O9wP4fcT6ojlUWqY3f
=eNhc
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_10_22_57_+1100_/0bWcySyk5bUbMaN--
