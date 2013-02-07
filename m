Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689Ab3BGVop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:44:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60733 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3BGVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:44:44 -0500
Date: Fri, 8 Feb 2013 08:44:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-Id: <20130208084442.d94a82546672286f421b0ee0@canb.auug.org.au>
In-Reply-To: <5112D13C.7030406@zytor.com>
References: <1356564746.7010.56.camel@shinybook.infradead.org>
	<50DB9FA5.6070704@infradead.org>
	<alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
	<20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
	<20130206214646.GA28135@gmail.com>
	<5112D13C.7030406@zytor.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_08_44_42_+1100_EekkB1ZS/82a97qU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_08_44_42_+1100_EekkB1ZS/82a97qU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 06 Feb 2013 13:55:08 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> So why don't we let Linus either accept and reject it for the 3.9 merge,
> but it rejected, we drop it from linux-next until such time as Linus'
> objections have been addressed?

It has been in linux-next since before v3.2.  It has been submitted
multiple times.  Last October, after not accepting it for the v3.7 merge
window, Linus said:

"I have yet to see a compelling argument for merging it. It's tons of
code, it doesnt match the original "small simple" model, and I think
it would be better off as a separate project."

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_08_44_42_+1100_EekkB1ZS/82a97qU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFCBKAAoJEECxmPOUX5FEdGsP/0eQQUXQ1aftRA+HPvDJJ+N9
VYYtMJ0nfRKFcYc9ZN1qdA4qqN5Vit+X4J3e3Go5k2tDM2ivWB+AWdMkQlqVBtU9
wCh7GePm8/SVhQA2H6xev/c6ZsjE/c9KKWlCFcq0xHXG9CjCqooR85y6yI03bYb3
E3Mj6rr/G0dr3plXIDKhEPgf3Rg6pI/uZIeU8FqGUW/4Qv7WUZNBTluYbS6ezKfp
PC6LCxrnLFyscEcezIZjBP6tfHbd9pwxnY88ka7fcJMRTuBn2gUiycz7wQmuzdBt
T0C2/lgEJDg1Vor9ra9D8PTSMjboCExcQ5u3YF/DXa2TV8F65ryvwNqbIQqnvZUa
mO5IeSkEWgJadVQsL2D+d6Elsd9MIZJdG2WxF9oRxqlZqYaHakCvTsI+cINhCyOP
+x/z9v3x+LPczuCOF+2X+zGBydfykUf4ACzDCqxRq2O2wCBIC7WFXrx/qAaM7ayA
XBeeVjv5X4ixnRf0i51wguaGtEDpXGHAjwteIp/j+zeWz1ddovuzbJCySy0k5tDU
ffs1RZhHiF+1VUd3ImYyiF99OV/+4A8Mdv2e+7fTUZvxP6FtvomuE9PvnkIXTi+u
zKvxiU1GYitXaX/a6osNSaTpCY5IG/wRamFiblwYvYCnG1+jR9sadZTQdWVqhK/V
WhWcYC3tqEhuZRqhTIc1
=HVS/
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_08_44_42_+1100_EekkB1ZS/82a97qU--
