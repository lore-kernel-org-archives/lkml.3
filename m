Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3HKLKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 07:10:22 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:52786 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3HKLKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 07:10:18 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Hard lockups using 3.10.0
Date: Sun, 11 Aug 2013 13:10:11 +0200
Message-ID: <2220835.PTjEcfuM0P@donald.sf-tec.de>
User-Agent: KMail/4.10.5 (Linux/3.9.8-1.gf3348a8-desktop; KDE/4.10.5; i686; ; )
In-Reply-To: <20130811083718.GA9461@pd.tnic>
References: <8484013.LsABBJRIOx@devpool02> <24155824.fdsQYPMaDK@donald.sf-tec.de> <20130811083718.GA9461@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2819055.cXaTavLn0j"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2819055.cXaTavLn0j
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Borislav Petkov wrote:
> On Sun, Aug 11, 2013 at 08:09:19AM +0200, Rolf Eike Beer wrote:
> > Meanwhile I found that there was a hardware defect on this machine.
> > So if it does not happen again I will assume that this was caused by
> > this.
> 
> What hardware defect exactly? DIMMs failing...? Probably, since it looks
> like the spinlock gets corrupted and the assertion fires... In any case,
> it would be interesting to know for future reference.

The RAM seems fine. It looks like it is the mainboard or a harddisk. The issues 
have magically disappeared since 3 weeks, but I have not done any suspend2disk 
since then anymore. Before that I had suspended the machine on the evening and 
resumed when I came to work. So it's possible that there was some corrupted 
stuff in the image.

This is the smart output I got of one disk yesterday:

Vendor:               /0:0:0:0
Product:              
User Capacity:        600,332,565,813,390,450 bytes [600 PB]
Logical block size:   774843950 bytes
scsiModePageOffset: response length too short, resp_len=47 offset=50 bd_len=46
>> Terminate command early due to bad response to IEC mode page
A mandatory SMART command failed: exiting. To continue, add one or more '-T 
permissive' options.

Eike
--nextPart2819055.cXaTavLn0j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlIHcRkACgkQXKSJPmm5/E4EegCeKKJ6MG7siF+cqcUMhXeYa5T+
ImAAoJsHIpsvUt+OzryHq8jomaPM84bK
=SvqI
-----END PGP SIGNATURE-----

--nextPart2819055.cXaTavLn0j--

