Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750765AbaHMEDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:03:30 -0400
Received: from ozlabs.org ([103.22.144.67]:53832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaHMED3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:03:29 -0400
Date: Wed, 13 Aug 2014 14:03:21 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, sfr@canb.auug.org.au,
        peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        hpa@zytor.com, tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>
Subject: Re: [tip:timers/core] timekeeping: Fixup typo in update_vsyscall_old
 definition
Message-ID: <20140813040320.GE14290@thor.bakeyournoodle.com>
Mail-Followup-To: John Stultz <john.stultz@linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	sfr@canb.auug.org.au, peterz@infradead.org,
	LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
	Paul Mackerras <paulus@samba.org>, hpa@zytor.com,
	tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>
References: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>
 <tip-953dec21aed4038464fec02f96a2f1b8701a5bce@git.kernel.org>
 <1407730744.4508.67.camel@pasglop>
 <53EA3320.90908@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <53EA3320.90908@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Aug 12, 2014 at 08:30:40AM -0700, John Stultz wrote:

> Thanks for pointing it out. I'll send a fix here shortly (though I only
> have the ppc64le toolchain handy, so forgive me if its not quite right).

/me pimps the kernel.org toolchains:
https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.9.0/x86_64-gcc-4.9.0-nolibc_powerpc64-linux.tar.xz

and gets back in his box.

Yours Tony

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJT6uOIAAoJEPvNNsFAAoTBghoQAOkqAGogn4eajMUBf0GhXLfy
ssEydHKZxOXIXg9Ers8FfHxvE7OPeyFmKjz4QLgVkjKyqJ11XrkHLKRWO/WO7fMf
8cpDWZShPHSDujO63gg8Flj3gi1ddwAXe4R2p9zSIc+bg+9/Ocu0klv6UcPqVyx8
X2jL80FNivTknM193ixneYQpAAfh+fAKxlwH/aVFve+mcF7jatoyDBJKKSqZocOa
iVSOh5wjkPfHcE3/IVlLsw/sLG7xhqliE1CQK/yEzdfrv0ZL52klLE2VHVGKDpJw
jxe91RcBJdl3O5kZxK6WDHKCD+tT51UrPpesJuEgDwwoEd1jLOpgRY6o4OKlXmsc
vJhAc/572kQpYz4g87KpgjgABQps893ofQNFhAu5IBF1mi70qCGFXVu9xLvEU4gJ
9MuNv4U82w9MLwPZ+pQY80q46Mq6oqgc1NQ/pk6h4sL/20qsbqENs3LrVdgv3WaW
vQJurKt0tHA61mqP5pMMSefxnoHCxnRtdhOlQGjmArZlGRGzvc6xnk+/40IXPJ8i
7GvrFLLH/dO5N1DLbnZYAqqN45nuZzvHufZGS820SW+XdLcyAoE2p00NmQdLlemo
bqiCUeL/X2ILEh/eUJd6e9SCO+iEemkNXgRy51tzrNgxR4TLIdu7oMMNrYOsCW8W
rOE4EBbrZiky3GfW340X
=pS1r
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
