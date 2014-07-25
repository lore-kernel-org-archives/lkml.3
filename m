Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935192AbaGYAtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:49:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37315 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900AbaGYAtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:49:32 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: filter: split filter.c into two files
In-Reply-To: Your message of "Thu, 24 Jul 2014 16:58:23 -0700."
             <CAMEtUuyw0PJXF_EWfs+PVzGago_waFXCbndT4B2HGJ0HYiXh2A@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com> <1406095319-3627-2-git-send-email-ast@plumgrid.com> <39107.1406245502@turing-police.cc.vt.edu>
            <CAMEtUuyw0PJXF_EWfs+PVzGago_waFXCbndT4B2HGJ0HYiXh2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1406249300_23260P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jul 2014 20:48:20 -0400
Message-ID: <42190.1406249300@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1406249300_23260P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Jul 2014 16:58:23 -0700, Alexei Starovoitov said:
> On Thu, Jul 24, 2014 at 4:45 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Tue, 22 Jul 2014 23:01:58 -0700, Alexei Starovoitov said:

> >> +obj-$(CONFIG_NET) += bpf/
> >
> > I was expecting to see CONFIG_NETFILTER here.  Is CONFIG_NET intentional?
>
> yes. it is config_net for now, until eBPF is completely separate from net.
> Then it will gain its own config_bpf, so it can be used in net-less setups
> or disabled in net-full setups by folks who care about last byte of .text size.

OH, OK. That works for me. :)

--==_Exmh_1406249300_23260P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU9GpVAdmEQWDXROgAQKSEw/+N+VkAVJm4CSfKPJaMCQaiHERnZiMioW4
GG2rIavZEGPC+d+vPnMycr/PN+izgmPxfuuHBGVHa5gfsf9VuRanOy9BLoTTxijF
fXbpC0Q1C8imsZZFny6m1yaNV/3V0+tkS8RTz+gbZrKMdB69WyPycrfkJQEgRrNY
Xs+p2OQJv4gJQCyJGMVludh3AiA8wPDVPYxEsFUx0xsR3LX8mh2y4dKEvUjw+4ue
QEcc9vZGU4F5nfKBaqx0o2Rgq0vleI36kc7dwH5xBYPPWhjEMEPRirjxNvXtO5Xk
qq45jNiLNm8OVCXLatHhSbDK51bpgRO4qU0eL3EqyBKu84l6Oe76qktCBX1teWXS
c3HxEpaF/CewTpdalDarqRgV7H5SICaaz2JA/tGJIiAScgwOEnXYhkZSVoqYtOy+
fjkYqGpJnHA1I2vWZNV/hfNTzp8ZjaW0wZyQ5YJXGuViV1AxKedT7P3Nm3dHQ1nk
QOvRKeP6U9dFG1vjXNpOif1qfeB0p8M9DQTQJg5ZP9gzQ+NEFQyvKgI5Wn0+WHO6
RRUzo8qMDtpTLtH49aVelf9jWFX2AF+78V9Zh6Z/ENfrpGfZL3zYtTJILo5zGjdX
cKJJ3ruQKDRJMUbvn7Vyh5SIAGlYGIB9o3ySJ48c/W/zX5uzC6kIdN0zqz1gB22b
wmXw0I41PZU=
=pwMw
-----END PGP SIGNATURE-----

--==_Exmh_1406249300_23260P--
