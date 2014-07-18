Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbaGRJuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:50:39 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55386 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbaGRJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:50:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for Exynos3250 ADC
Date: Fri, 18 Jul 2014 11:50:23 +0200
Message-ID: <6104032.PNRl85V92G@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405663186-26464-4-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <1405663186-26464-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3WTN/LqhesSshdfHDfcCioyS9YmTDfBxnX637eSpUWK
 8aVpSLc5viN+eFgFQ+qEXpLf8fR7UqVknplnSjQMXWwEv8cgx2
 eBa37kSMS8BCgJKnwk86p5mS5n6d9uT2JM0Yi9wxFAfMTWHvR+
 eQreCUxYBTzYmkHBluckMAsJUS6XfqxpWCLaNX+DGZHIr1djN7
 KwLr2IND0zmg+rYXT55HXdpL3aSAtnxN82mr6FOmgti62LyIdq
 9oz3pDtQ6nSoE5/8epKzfOvoSLvpYizfRbvNazIONQL/kodcRb
 ASIQ5VTJoYVRN4/I4nG0zrJ791J3+T87FS3+8dz31rQ3KehkLj
 6uyMHstieqCx7ZczUBf0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:59:45 Chanwoo Choi wrote:
>                         Must be "samsung,exynos-adc-v2" for
>                                 future controllers.

It would be good to change 'future controllers' to something else now.
Presumably that word was used before the actual products were announced,
but now they are publically known.

> +                       Must be "samsung,exynos3250-adc-v2" for
> +                               controllers compatible with ADC of Exynos3250.

Doesn't this version have a specific name as well? The ADC block
seems to use version numbers, so better put those in here to avoid
confusion when another Exynos7890 comes out that uses the same
ADC as exynos3250.

	Arnd
