Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3KZIIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:08:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50464 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3KZIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:08:17 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-c3-529456f0bde2
Message-id: <529456EF.501@samsung.com>
Date: Tue, 26 Nov 2013 17:08:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com, a.sim@samsung.com
Subject: Re: [PATCH] extcon: fix switch class porting guide (Documentation)
References: <1385452659-19417-1-git-send-email-myungjoo.ham@samsung.com>
In-reply-to: <1385452659-19417-1-git-send-email-myungjoo.ham@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkUPdD2JQgg2NfeC3eXelgtLi8aw6b
	xfNNnawWtxtXsDmweOycdZfdo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDIudk9kL5jMXLHz
	VyNjA+Nxpi5GTg4JAROJTbPeskPYYhIX7q1n62Lk4hASWMoocay5G67o2JI/LBCJ6YwSc54f
	ZYRwXjFKHP35HaydV0BN4t3Hk6wgNouAqsS2SR/YQGw2AS2J/S9ugNmiAmESK6dfYYGoF5T4
	MfkemC0ioC3x+8ZDMJtZwFti+84tYDOFgeyPX8+C9QoJeEgsnToLyObg4BTwlDh5Wg6iXEdi
	f+s0NghbXmLzmrfMEEcvY5d4dtcA4hwBiW+TD7GAtEoIyEpsOgBVIilxcMUNlgmMYrOQHDQL
	ydRZSKYuYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYQ6f/PevdwXj7gPUhxmSglROZ
	pUST84ExmFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjDO318W4tG6ffn+1mZPD1H/r9IMmthXqrvx32kJA/GNowbNFx791Ol36JM7Pmjq1429b
	W7xYVfr+7wsfi9hsreyrWPtpd9yJrKrAYwJ7QvgLjXv+Xd5sYs9vcE5c7kLWGmuTuyedPOXa
	3p9RPbl6roRASJBI88Tuy8eeCsUsvV7OqS+UwjJ7lhJLcUaioRZzUXEiAKBe8iu3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO6HsClBBrc/slm8u9LBaHF51xw2
	i+ebOlktbjeuYHNg8dg56y67R9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmXOyeyF4wmbli569GxgbG40xdjJwcEgImEseW/GGBsMUkLtxbz9bFyMUh
	JDCdUWLO86OMEM4rRomjP7+zg1TxCqhJvPt4khXEZhFQldg26QMbiM0moCWx/8UNMFtUIExi
	5fQrLBD1ghI/Jt8Ds0UEtCV+33gIZjMLeEts37kFbKYwkP3x61mwXiEBD4mlU2cB2RwcnAKe
	EidPy0GU60jsb53GBmHLS2xe85Z5AqPALCQbZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4Bh9Jr2DcVWDxSFGAQ5GJR5eic7JQUKsiWXFlbmHGCU4mJVEeF3vA4V4UxIr
	q1KL8uOLSnNSiw8xJgMDYCKzlGhyPjB95JXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDY2io3u5W4St7m39uPnArSPn7WhauNp50izf8/3jmhcx+WnV9msGj
	2Hkf5ltZf8l/v+Hblp5vWlIyJhluy/IDuNbIKs7XPH3GaIqRlDtDmNORuWGdvdf9jC5+mKKq
	eyNQyXVZ1ZRWtuhP0VIzJ035/N4m6mNSb7fVh/ptMTlaQs3rVuVtD95mpcRSnJFoqMVcVJwI
	AISi9kQVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:57 PM, MyungJoo Ham wrote:
> - Unfinished sentence finished.
> - Incorrect description on the compat-mode condition corrected.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  Documentation/extcon/porting-android-switch-class |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 

Applied it.

Best Regards and Thanks,
Chanwoo Choi

