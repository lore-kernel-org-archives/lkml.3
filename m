Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3K2AIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:08:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42619 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3K2AIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:08:13 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-b5-5297daebf330
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
 <20131128135054.GK27568@sirena.org.uk>
In-reply-to: <20131128135054.GK27568@sirena.org.uk>
Subject: RE: [PATCH v2 1/5] mfd/rtc: s5m: Fix register updating by adding
 regmap for RTC
Date: Fri, 29 Nov 2013 09:08:13 +0900
Message-id: <05c401ceec97$18af46c0$4a0dd440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIn7cDk689h23sBcLg83vR3zAVxUwHfHDnQAxO2sLmZYbr7gA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+Zge7rW9ODDFZd0bBYcvEqu8XUh0/Y
	LJ7d2stk8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt9jf2cFocbqb1YHbY+esu+we
	eyaeZPPYtKqTzePOtT1sHocOdzB6zDsZ6NG3ZRWjx/R5P5k8Pm+SC+CM4rJJSc3JLEst0rdL
	4MrY9/AES8EE5orP8xqYGhgPMHUxcnJICJhILPnSywJhi0lcuLeerYuRi0NIYBmjRPelHSww
	RTvObWOBSCxilLj9aBlU1R9Gic0vTzGCVLEJaEis3P2WDcQWEYiQmHz0IDtIEbPAWyaJhc0T
	mCE61jFK/L47B2wup4CxxOrPm8G6hQWiJJa+vgJ2FIuAqsS11W/YQWxeAUuJI/8+MUPYghI/
	Jt8D62UW0JJYv/M4E4QtL7F5zVtmiFsVJHacfc0IcYWTxMFbB5ghakQk9r14xwhyhITAQg6J
	9ocHGCGWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCgxC8nqWUhWz0KyehaSFQsYWVYxiqYW
	JBcUJ6UXGekVJ+YWl+al6yXn525ihKSDvh2MNw9YH2JMBlo/kVlKNDkfmE7ySuINjc2MLExN
	TI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj13WeN45as+d0bUp/
	tCRf+flym7iSiT4veNR83ls0Lm4zW6lx5ieTheS18LrQ7wtPxYWuWaK2TGuWmNGTaXpKgWec
	C9yY3n3/uEc7bzFD2mQrkZ2m684e/XIntDKec7KfUrPAgb9vJi+4Zz9j+bL1JwwfVXY2algy
	OzbxqAVxVexVuv+0I/WNEktxRqKhFnNRcSIACMyiVR0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAd3Xt6YHGVzfp2yx5OJVdoupD5+w
	WTy7tZfJ4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CzWHrnLbrG/s4PR4nQ3qwO3x85Zd9k9
	9kw8yeaxaVUnm8eda3vYPA4d7mD0mHcy0KNvyypGj+nzfjJ5fN4kF8AZ1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4xY9/DEywFE5grPs9rYGpgPMDUxcjJISFgIrHj3DYW
	CFtM4sK99WxdjFwcQgKLGCVuP1oG5fxhlNj88hQjSBWbgIbEyt1v2UBsEYEIiclHD7KDFDEL
	vGWSWNg8gRmiYx2jxO+7c8DmcgoYS6z+vBmsW1ggSmLp6ytgu1kEVCWurX7DDmLzClhKHPn3
	iRnCFpT4MfkeWC+zgJbE+p3HmSBseYnNa94yQ9yqILHj7GtGiCucJA7eOsAMUSMise/FO8YJ
	jEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONk8k97BuKrB
	4hCjAAejEg/viu7pQUKsiWXFlbmHGCU4mJVEeH8VAYV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZ
	SjQ5H5gI80riDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0fd0
	Ws3S1q8c5gcCdRYx3H01c2Ksx+O9rE9elaZMW+bOMSXes674vPVzc6CJ7gs+lO09vD1R89If
	6TefD1Qc56qZLLf6/IKcxDTDri+e3LfC3f1/3ru0L4PttKL2ZbsIE+Mr4tcXbgmRKZP6wu52
	cIKl04yEO306ur92bbN5sLb81slNU4Q5lFiKMxINtZiLihMBQbJW7XoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 10:51 PM, Mark Brown wrote:
> > On S5M8767A registers were not properly updated and read due to usage
> > of the same regmap as the PMIC. This could be observed in various
> > hangs, e.g. in infinite loop during waiting for UDR field change.
> 
> Reviwed-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

