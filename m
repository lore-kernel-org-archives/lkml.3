Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3FMMEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:04:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3FMMEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:04:10 -0400
X-AuditID: cbfee68e-b7f276d000002279-bd-51b9b53992a3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Luigi Semenzato'" <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-kernel@vger.kernel.org
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
 <1371058399-31933-3-git-send-email-dianders@chromium.org>
In-reply-to: <1371058399-31933-3-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts before
 unmasking
Date: Thu, 13 Jun 2013 21:04:09 +0900
Message-id: <150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5nkvaShSRgyCEKREqca56h3EqRrwAmsiow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zA13LrTsDDb7eV7Q4u+wgm8WzO1eY
	LY7+W8hoMeXPciaLy7vmsFmcuv6ZzeLz1S8sFt+2bGO0WLXrD6MDp8fshossHjtn3WX3uHNt
	D5vHlRNNrB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVsencWsaCwywV/xYtYG1gvMfcxcjJ
	ISFgInHw9D0mCFtM4sK99WwgtpDAMkaJJ1NLYWqO7ZnC2sXIBRSfzijRceAkE4Tzl1Fiecsj
	sA42AQ2Jw++fsYPYIgKREhMOnGMGKWIWeANU9PwdVHsjo8TFOfvAqjgF3CR+Hb7PCmILC0RL
	7Jj+FewOFgFViSs7jjKC2LwCthJnTvRB2YISPybfYwGxmQUMJN7P6mOFsLUlnry7AGRzAN2q
	LvHory7EEUYS99dfhCoXkdj34h0jyA0SAq0cEq3TPjFC7BKQ+Db5EAtEr6zEpgPQYJGUOLji
	BssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJL77djDe
	PGB9iDEZaP1EZinR5HxgesgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA6OgjPeO5238V9T+zD2gsOdSeqzzJK+O1xsl3u1/OJcxsDUhLrAuk3Xa
	139feFSdFp+YMKt390fpfdy+tdMuL5Vc4Befoca4N9VXdM3BPQ375go1dDU1bIne5Ji/Sv+J
	z708S8OX7BEl2224L5xIkN7hO6fzxZNH0g3mvzks/a4binC9ElxQ3qfEUpyRaKjFXFScCAA0
	UOI5BQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jQV3LrTsDDU5Ok7U4u+wgm8WzO1eY
	LY7+W8hoMeXPciaLy7vmsFmcuv6ZzeLz1S8sFt+2bGO0WLXrD6MDp8fshossHjtn3WX3uHNt
	D5vHlRNNrB59W1YxenzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkDdJaSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCO
	MWPTubWMBYdZKv4tWsDawHiPuYuRk0NCwETi2J4prBC2mMSFe+vZuhi5OIQEpjNKdBw4yQTh
	/GWUWN7yiA2kik1AQ+Lw+2fsILaIQKTEhAPnmEGKmAXeABU9f8cK0dHIKHFxzj6wKk4BN4lf
	h++D7RAWiJbYMf0rE4jNIqAqcWXHUUYQm1fAVuLMiT4oW1Dix+R7LCA2s4CBxPtZfawQtrbE
	k3cXgGwOoFvVJR791YU4wkji/vqLUOUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxgtPHM+kdjKsaLA4xCnAwKvHwvrywI1CINbGsuDL3EKME
	B7OSCO/NqTsDhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmNrySuINjU3MjCyNzCyMTMzN
	SRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoEx4cqCR7k/O2tfiz34enFGoEMei17bZ5fQ
	74z7hT3Wf0zVfs1SwiNnanGx/tIVW9GPC7p/fY/bqHM6d09+HOePVys55z41Xt6jVfT+2+nA
	nzWOJ1mNk1+7656LX+DGZ3fB0+HW5sLNPWIC+o7ftQ+7rzsoWFb6SvXny2lm+1oP2/QXBbpq
	P3mmxFKckWioxVxUnAgAblpxnGMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> A level-triggered interrupt should be acked after the interrupt line
> becomes inactive and before it is unmasked, or else another interrupt
> will be immediately triggered.  Acking before or after calling the
> handler is not enough.
> 
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

BTW, probably we need a similar fixing in the mach-exynos/common.c file
before pinct±â for distro...

Anyway,
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
- Kukjin

