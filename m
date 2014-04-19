Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaDSShA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 14:37:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34703 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaDSSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 14:36:54 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Cc: kernel-br <kernel-br@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>, jikos@jikos.cz
Subject: Re: [Kernel-BR] Re: [RFC] Only a.out QMAGIC format is working
In-Reply-To: Your message of "Sat, 19 Apr 2014 13:37:27 -0300."
             <CAGG-pUQ5+dv566KZK2hbQENXSEPaY5k5fapgnLUE0jTv1ihPMg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com> <20140419161552.GB27776@amd.pavel.ucw.cz>
            <CAGG-pUQ5+dv566KZK2hbQENXSEPaY5k5fapgnLUE0jTv1ihPMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397932407_2032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Apr 2014 14:33:27 -0400
Message-ID: <108530.1397932407@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397932407_2032P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Apr 2014 13:37:27 -0300, Geyslan Greg=F3rio Bem said:

> Maintainers, is there some chance to fix it or a.out is really doomed?

Is there an actual use case for a.out on a modern kernel?

In other wods, is there any reason to really care if it's doomed, since
it's been *years* since that worked?

--==_Exmh_1397932407_2032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU1LBdwdmEQWDXROgAQI4BA/+OCAda9fXv16PC2klhSF6lkcdwe/8SMeu
RlS+GPYNPR3f8g1NkFGkg9HmSI+p6x5yGrIPlKzwldqBeDT3FONtbl6oetGd/Jhd
tgmOJFqvbORHl9VqNGHvKLeHxr5efOwJAeK8oRp1QkW0OiH+KWnzPBb/qxg2bxdt
KXot0B60dWfQm4w7iIrmgS1FcFgXmCOFV5wo2vUWr9FetP+jyVWqvjxB0a/8kqGz
UH3H4SHsRe6cIui9PJ3eek/n4aZ3ThZlkYM8jekY7fr+BD5qLxvRmoWwoukEucEL
8adRocjeA8hfIv0trHINEpf0/21pGws5+gfuI0iyBwnjgvDthGM+ioNzvJsEwJlo
hlmFq6ceVrqjuovw8888+/uu5z2pVzCLZleCS6twTYdi1eunaSc45UtO3WubWoJC
CNj0IKwfMDpL7tn7cmZdIEfRyOY0rlemFBZi6PCZKxVwbscm/9xC1urVEoP4i6i1
vsi7/xDXETtJP4p0bKF0NUE+wlNPdkBsOQxyJwITdqBUtcq80ACqnKfc6sevgStn
6OeS4jsB4AzrPVG4ddKODYmrIfh58gqlndhs85MJIay2GDF7PPz5QhYYEUjkhsCl
Rg9aEGThhhnuD3aDBlLjjul8RuvWcvYogzrRfxO2FkUiZQxUnFFfvRNPWs+8veoE
vm4ZMJLLXv0=
=ueAZ
-----END PGP SIGNATURE-----

--==_Exmh_1397932407_2032P--
