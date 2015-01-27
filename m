Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbbA0L1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:27:42 -0500
Received: from smtpbg63.qq.com ([103.7.29.150]:52059 "EHLO smtpbg63.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780AbbA0L1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:27:39 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 06:27:39 EST
X-QQ-mid: bizesmtp7t1422357399t363t289
X-QQ-SSF: 01400000000000F0FPF2
X-QQ-FEAT: JNrLgFxDiy2Z/G1AEgubCjy4ztnBf2nDNABpmOEAejHgdmfFYyB+ywEXBUliR
	j8N9GDzkT0+5dfnvsYdmSJx6JTJ5yShlR54x5CSocuf/3MKeoKiNEnDHpGZxkPkwxaTI5yH
	pbcIESD5Ys39T0yOoQu5tX1HmFczKFp4zA0HxrcszOUMKK/FUShzvUXok9z0kMe8NfdsyvR
	1nN++qXARzxdX6WzAEO3p
X-QQ-GoodBg: 2
Subject: Re: [PATCH] irqchip: GICv3: ITS: Allocate enough memory for the full range of DeviceID
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: multipart/signed; boundary="Apple-Mail=_68C08ABB-8EFD-46D9-9FC8-200D2360885D"; protocol="application/pgp-signature"; micalg=pgp-sha512
X-Pgp-Agent: GPGMail 2.5b4
From: Chen Baozi <chenbaozi@kylinos.com.cn>
In-Reply-To: <1422327961-19733-1-git-send-email-baozich@gmail.com>
Date: Tue, 27 Jan 2015 19:15:16 +0800
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>
Message-Id: <15CDAC06-1E2B-4545-93E8-CBB4B47E2707@kylinos.com.cn>
References: <1422327961-19733-1-git-send-email-baozich@gmail.com>
To: =?utf-8?B?6ZmI6bKN5a2c?= <baozich@gmail.com>
X-Mailer: Apple Mail (2.1993)
X-QQ-SENDSIZE: 520
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_68C08ABB-8EFD-46D9-9FC8-200D2360885D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 27, 2015, at 11:06, Chen Baozi <baozich@gmail.com> wrote:
> 
> The ITS table allocator is only allocating a single page per table.
> This works fine for most things, but leads to silent lack of
> interrupt delivery if we end-up with a device that has an ID that is
> out of the range defined by a single page of memory. Even worse, depending
> on the page size, behaviour changes, which is not a very good experience.
> 
> A solution is actually to allocate memory for the full range of ID that
> the ITS supports. A massive waste memory wise, but at least a safe bet.
> 
> This patch has been tested on the Phytium SoC.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Failed to clarify that Marc is the author of this patch.

Sorry for the mistake.

Cheers,

Baozi.


--Apple-Mail=_68C08ABB-8EFD-46D9-9FC8-200D2360885D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJUx3NJAAoJEA9jpU/ZEyvnLIEP/jHVyddng9Ve/lLXgtJODX3z
0P3P2jpTiL6wJg/9O6Q0V06CC74e7lSr9ONOcSZHwLIgdzULwftzpqoI9sWyio6N
sWoY5Q/iVPT5CwfD5ZveXpRM2/mw54ERwIyn/pYyAUmR2vNds9PMf/ZysOLg9gvq
xl+F7fv0lULq88E0tpaKXvs7bkWPo8PoDzc22fRLi7BH53Zi03MKQ4PMPJ+FSEve
XOKpzdp1+B0IzS55poCJ7/nFnMbZqktshrbK5Nz8kD8iuTKsVBbIzJye5yteluAB
rO/BFz+DSWBpuHkJYTPXrH30t9DSxFXWcg6YBWjPzXCdET7Pg8pblbsgx6h8FdR2
fRT4NAOSFb/VrwqZpMOCGaJZCSIDZdY80XRncul8KaA35N9gOWF13j/X/1F9aASx
xj4Mrxuz1nGTF52igiHWCpxplQBO9Aq+jnulP6M+o7wiATIPycbEVYvSU/qLufJH
WoUgANP4id99Cdx3ugTFiXW49SFXT3wKKUsVRsh5GB0j2MEllMNR6Y6cz0njSpvP
nCHC2ctsJszO6LcFvpJYp53Pcq/BpQxA6Kt/WeIbGtEqHEIr0aPy+N64mPV1Btig
NoGuWV0i5hPjsS6eRc6QsAhhjYFIX1lJ9O1S/3tFupG9FpeX0/zSEXiu7eWI9GAw
Vd7iVKdu4mI4lgK+5buZ
=0Y4A
-----END PGP SIGNATURE-----

--Apple-Mail=_68C08ABB-8EFD-46D9-9FC8-200D2360885D--
