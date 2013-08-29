Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3H2AZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:25:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51042 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3H2AZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:25:47 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-fb-521e9509977c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc: "'Anton Vorontsov'" <anton@enomsg.org>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com> <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda>
In-reply-to: <20130828083630.GF19256@mwanda>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Date: Thu, 29 Aug 2013 09:25:44 +0900
Message-id: <001a01cea44e$4d1e0360$e75a0a20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jydD4V4GuPt+oQKe/CjJRTkYZSgAgv59w
Content-language: ko
x-cr-hashedpuzzle: GBY1 LHi5 TIzw X0t5 dgKR d8lS eq9Q wyT3 0wuP ABpUpQ==
 AEFkcA== AEsx6Q== AEtcIQ== AIq0Rg== AJNFQA==
 AKL4Xw==;9;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAbgB0AG8AbgBAAGUAbgBvAG0AcwBnAC4AbwByAGcAOwBiAHIAbwBvAG4AaQBlAEAAawBlAHIAbgBlAGwALgBvAHIAZwA7AGQAYQBuAC4AYwBhAHIAcABlAG4AdABlAHIAQABvAHIAYQBjAGwAZQAuAGMAbwBtADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGcAcgBlAGcAawBoAEAAbABpAG4AdQB4AGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAG8AZQBAAHAAZQByAGMAaABlAHMALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{270EA80C-0723-42D3-A818-4DB44030CB75};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 29 Aug 2013 00:25:28
 GMT;UgBlADoAIABbAFAAQQBUAEMASAAgADMAMwAvADMANQBdACAAcABvAHcAZQByADoAIAB1AHMAZQAgAGQAZQB2AF8AZwBlAHQAXwBwAGwAYQB0AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {270EA80C-0723-42D3-A818-4DB44030CB75}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t8zY13OqXJBBhMOsVjMWb+GzeLgVk2L
	qQ+fsFm8/jedxWLiysnMFs2L17NZXF54idVi9v3HLBaXd81hc+D0mND/idFj8wotj02rOtk8
	Tsz4zeKxf+4ado+PT2+xeHxZdY3Zo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0SuDL+XOUrWMZa
	cajvN1MD4wyWLkZODgkBE4n5jzewQdhiEhfurQeyuTiEBJYxSnx7Pp0VpujPno+MEIlFjBIz
	vuxmgnB+MUo8v/iDHaSKTUBN4suXw2C2iICexNTF+5lAbGaBg0wSG07qQDTsZ5L4/XEHI0iC
	U0BHYsfFl2ArhAUsJNq7W8GaWQRUJfb9/wgW5xWwlXi0Zhs7hC0o8WPyPRaIoVoSm7c1sULY
	8hKb17xl7mLkADpVXeLRX12IG4wk3nxYxQZRIiKx78U7RohvFrBLbDlTDWGbSpzZPwEqvpJD
	YsZOTYgTBCS+TT7EAjFSVmLTAWaIEkmJgytusExglJqF5KBZSA6aheSgWUg2L2BkWcUomlqQ
	XFCclF5kqlecmFtcmpeul5yfu4kRkiQm7mC8f8D6EGMy0PqJzFKiyfnAJJNXEm9obGZkYWpi
	amxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbnuRnLNk98f3KbJ/OU
	lpk3pPhvNX3PPilyWnvVvpeLrGvX9qnMu/1Pe5pZ2ln/X3df5HA+fWIhlpu5J2jfHIk1iltP
	d81kEfuxedOhxhsL/+XurIzSMer//PblkZqHRVq/18psWRotKbU7f6vJp+ldLW/Dt04TWBW+
	aUXRCe6WBKGXPy0bdsz6oMRSnJFoqMVcVJwIANCqY4QoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t9jAV2OqXJBBis/2VjMWb+GzeLgVk2L
	qQ+fsFm8/jedxWLiysnMFs2L17NZXF54idVi9v3HLBaXd81hc+D0mND/idFj8wotj02rOtk8
	Tsz4zeKxf+4ado+PT2+xeHxZdY3Zo2/LKkaPz5vkAjijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jFm/LnKV7CMteJQ32+mBsYZLF2MnBwSAiYSf/Z8ZISwxSQu3FvP1sXI
	xSEksIhRYsaX3UwQzi9GiecXf7CDVLEJqEl8+XIYzBYR0JOYung/E4jNLHCQSWLDSR2Ihv1M
	Er8/7gAbyymgI7Hj4ktWEFtYwEKivbsVrJlFQFVi3/+PYHFeAVuJR2u2sUPYghI/Jt9jgRiq
	JbF5WxMrhC0vsXnNW+YuRg6gU9UlHv3VhbjBSOLNh1VsECUiEvtevIP6ZgG7xJYz1RC2qcSZ
	/RMYJzCKzEKyYRaSDbOQbJiFZNQCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFJ6Jn0
	DsZVDRaHGAU4GJV4eCN+ywYJsSaWFVfmHmKU4GBWEuGdkikXJMSbklhZlVqUH19UmpNafIgx
	GRgAE5mlRJPzgQkyryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoY1/K9uaXJWHpa8Jn+i68zbwnmfTvS/SYt7biJ5o4A35JLtzTeNc93kXVZ2NeUu38Lc4H3
	m+Oz9nXdlzt+dhtPzo6WuAkVF3xZJV8uOKYtsGeFdsz3cDOuPmvJxhRD3oLpgXZWDUIq8i4O
	OS0OaavnB6uofqlWVlPwUvW98je5dalMSn/wrxNKLMUZiYZazEXFiQCpejx3hgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 5:37 PM, Dan Carpenter wrote:
> 
> He doesn't want to take the patch.  He's the maintainer so it's his
> choice.  That's the end of the story.
> 

I know that the maintainer's choice is important,
because I am also a maintainer of other system or drivers.

But, there is no reasonable reason to object my patch.

I sent all 35 patches that use dev_get_platdata().
21 patches of 35 patches have been merged by each maintainer.
The maintainers admitted that these patches make the code simpler
and enhance the readability, even though these are cosmetic changes.
Also, until now, there is no objection.

Best regards,
Jingoo Han

