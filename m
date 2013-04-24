Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab3DXHPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:15:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab3DXHPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:15:50 -0400
Date: Wed, 24 Apr 2013 09:15:47 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V3 1/3] pwm: pxa: ARCH_MMP share same pwm driver with
 ARCH_PXA
Message-ID: <20130424071547.GF1429@avionic-0098.mockup.avionic-design.de>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
 <1366770234-5829-2-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0hHDr/TIsw4o3iPK"
Content-Disposition: inline
In-Reply-To: <1366770234-5829-2-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zUs3zT/8zRxdygkTCQBW0z/vHgtSPUEEQ4+sEwHB321
 +7BuW8vcRqbxQlGZ+I9NC/jqcXPZPQikcQqTKLMd3ljN1JdtCQ
 LjWbnFyyBF9Rjce+nAEAjBdtxClytyQT/9YEqN+KqgaJ4bwGDu
 xs1v5euFlzJat/acE1BUaItpVNJbQBuDFAFwye/ueNSdoE3jYu
 qsCLzsylT0v/9ddvefeoMaIWhWAlva9gDybyZ5g7HP3aMZOM1g
 MYxISVjf4B3ppOEWD4gUzIihcY9U4rJLyiXYHwm19s2Ho2AIRz
 ALNshnEmM5Rs5p6F6JDa2yyWs5rFDho5Rl3nmLGO+OucNqeqHa
 3MAqPa9mnpGrwdG7o6vJfnu20dkwaPaVaJau+V5sFa+vNpuRX0
 pW03mztbjX6JB6+9kdjCNFhQpZgTUutMkDAKgzzj/Dvo0+oQRQ
 uB1d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0hHDr/TIsw4o3iPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 10:23:52PM -0400, Chao Xie wrote:
> the pwm driver is not only used by ARCH_PXA but also ARCH_MMP

Please use only uppercase PWM in prose. Also the commit description is a
full sentence so it should start with a capital letter and end with a
full-stop.

Thierry

--0hHDr/TIsw4o3iPK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4ajAAoJEN0jrNd/PrOhmScQAJTaazS8DnZzHj03gSu5UU57
3ymwMIB+YNdxYxNqVhctMeoCECbmxlTiZAXuEV9lEDJuER1qVZOsLb1YIbdqO1aJ
2mn0bqsWAgFsg4h1RBLMAmv2Z74ux4T+1askekQzEPYvEfpPZF8kJMcdCAn8igIm
vvrC5xNhQ78oGqWjpv6UHmWiCWRVUsq1+QtzpFotfeeMzzAcE/RgOkr/D60r0jvH
P17af6iBDMR4QSbi619/BL+MsS03ZHMyXarH/P4ZS5F/A9+MF4IY4PShsp7BmpIX
8L4D42eWORDCK4i0cfJuSgj14JVCBVCqZ6/TbDgaoMEb9jKaY6/M2j7eZvd6eAKe
rOzKrotADtSIVnI/8ml0Hupvvw707uyH2ZjxZxgKc4FpQ+di0VACFeEl3RHO94bJ
hUpJjgVZrgKweJzC1tAWCdOodxosLn/jsJ/mBBMYJz4eMILvrEusag8us19Cghj3
S6WBfzEHF3t+lMGqe1eijQJp+xKKtWKtC++Y3C8afqY7j5U1muUVFl50W20iJVGA
p7+/hudwpQ6gQ61wcn6EN2dicPSx/aJTc1KH1sx3nqbcdMz7m0XJCixeyP4V8Akq
ge1sSyheqNpjf7uUL/TxywsM5UrQ9qpoVj08T2YuWr/NZUVW7yjXabkMGV/hdStX
661tJJ5rzIO5SXcSeO0J
=U7np
-----END PGP SIGNATURE-----

--0hHDr/TIsw4o3iPK--
