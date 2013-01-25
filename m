Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3AYCEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:04:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40987 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3AYCEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:04:34 -0500
X-AuditID: cbfee611-b7f1c6d000002752-41-5101e8316669
Date: Fri, 25 Jan 2013 02:04:33 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-s5p/ohci-exynos: Fix compatible strings
 for the device
To: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130125020408377@jg1.han
Msgkey: 20130125020408377@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130125020408377@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12939188.154411359079472121.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELsWRmVeSWpSXmKPExsVy+t8zQ13DF4yBBucniFlc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM2P+rl7lgFVvF518HWRsYJ7B1MXJyCAkoSUw6uZcRxJYQMJG4+P8X
	M4QtJnHh3nqgGi6gmmWMEjtnLGbqYuQAK9qx2QsiPp9RYsLWSWCDWARUJfo6drCD2GwC6hIT
	fjezgNjCAjESH/4uZQWxRQQyJLoeHmQHaWYWeMwq8fzhO3aIK2Ql7k2eDbaZV0BQ4uTMJywQ
	VyhIXJuxnAUirigx5f47Joi4hMSd+/tZIWxeiRntT6Hq5SSmfV0D9YG0xPlZGxhhvln8/TFU
	nF/i2O0dUM/wSjy5HwwzZvfmL2wQtoDE1DMHoVpVJWY9XcQOYfNJrFn4FmqVoMTpa93MML0N
	G3+D1TCDnNn9EMrWkvjyYx8burd4BZwkLj9ZwjKBUXkWktQsJO2zkLQjq1nAyLKKUTS1ILmg
	OCk91Rw5tjcxQhKh4A7GpQ0WhxgFOBiVeHgfJDMGCrEmlhVX5h5ilOBgVhLhdYkACvGmJFZW
	pRblxxeV5qQWH2LczwiMwonMUqLJ+cA0nVcSb2hsbGJmYmpibmlqbkqBsLmRqQEwYRsYUkdY
	SZyXs2J6gJBAemJJanZqakFqEcwLTBycUg2ML1Lms04TTNxh4HN3V+th4b97E7sar1kbHFW4
	HbzstkRv9IHHt248Ps7SFBj+/7PDAffw7q+Nok+/WX5ZE8v7ZrnxkSvFpjsXdt0pVa36uPBB
	593Uv0J5qasuPc6RDUq6fSnEJnPa7i319Y8d1gl0qbBkyq65tM93taQd/8VclvTqbeZpT/lf
	K7EUZyQaajEXFScCAFCRt34lBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TF3DF4yBBpP/Clpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jP2/epkLVrFVfP51kLWBcQJbFyMnh5CAksSkk3sZuxg5OCQETCR2bPYCCUsIiElcuLceqIQL
	qGQ+o8SErZPA6lkEVCX6Onawg9hsAuoSE343s4DYwgIxEh/+LmUFsUUEMiS6Hh5kB2lmFnjM
	KvH84Tt2iGWyEvcmz2YGsXkFBCVOznzCArFNQeLajOUsEHFFiSn33zFBxCUk7tzfzwph80rM
	aH8KVS8nMe3rGmYIW1ri/KwNjDBXL/7+GCrOL3Hs9g4miMd4JZ7cD4YZs3vzFzYIW0Bi6pmD
	UK2qErOeLmKHsPkk1ix8C7VKUOL0tW5mmN6Gjb/BaphBzux+CGVrSXz5sY8N3Vu8Ak4Sl58s
	YZnAKDcLSWoWkvZZSNqR1SxgZFnFKJpakFxQnJSeaq5XnJhbXJqXrpecn7uJEZyingnuYFza
	YHGIUYCDUYmH90EyY6AQa2JZcWXuIUYJDmYlEV6XCKAQb0piZVVqUX58UWlOavEhxmRgDE5k
	lhJNzgemz7ySeENjYxMzE1NzAwsDS3PShJXEeTkrpgcICaQnlqRmp6YWpBbBbGHi4JRqYOxs
	mBIV7XJ2a3/TJY0zfAKhRv8MPfIuZf5s4FeSkEmYv3e22iHvhYYNV5dHfuOXKJzjGWHmeeJq
	0KFDt2d8/CR2k/ulRdyHQ3OvreJ9f6g93eZE1tZD98ridrt+5b83IWbmyVXnZzaviT3k9jQ6
	xuOIzodfDJm3eePbZzJ9ezH3/5KcBq75SrxKLMUZiYZazEXFiQC14XLelQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0P24hZ5016806

On Thursday, January 24, 2013 10:45 PM, Vivek Gautam wrote
> 
> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/ehci-s5p.c    |    2 +-
>  drivers/usb/host/ohci-exynos.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
