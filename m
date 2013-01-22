Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3AVERv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 23:17:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52328 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3AVERt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 23:17:49 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-43-50fe12ebf9b8
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Wolfram Sang'" <w.sang@pengutronix.de>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-31-git-send-email-thierry.reding@avionic-design.de>
In-reply-to: <1358762966-20791-31-git-send-email-thierry.reding@avionic-design.de>
Subject: Re: [PATCH 30/33] video: Convert to devm_ioremap_resource()
Date: Tue, 22 Jan 2013 13:17:47 +0900
Message-id: <000501cdf857$6f33c780$4d9b5680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac33wJ8uyE8lhinRT1qXBVC8UPvXYAAlgyyA
Content-language: ko
x-cr-hashedpuzzle: COBj GzbR PBZ1 RPcy RP+Z kRG6 lIiJ lteB l1Bv uUPS u7Za
 AC8oKw== ADpoFA== AGlS0A== AJCOcA==
 AJpYhg==;9;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGQAbQBpAHQAcgB5AC4AdABvAHIAbwBrAGgAbwB2AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBmAGwAbwByAGkAYQBuAHMAYwBoAGEAbgBkAGkAbgBhAHQAQABnAG0AeAAuAGQAZQA7AGcAcgBlAGcAawBoAEAAbABpAG4AdQB4AGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBmAGIAZABlAHYAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB0AGgAaQBlAHIAcgB5AC4AcgBlAGQAaQBuAGcAQABhAHYAaQBvAG4AaQBjAC0AZABlAHMAaQBnAG4ALgBkAGUAOwB3AC4AcwBhAG4AZwBAAHAAZQBuAGcAdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{09E18F68-4E95-446B-81AD-61019344EDF1};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 22 Jan 2013 04:17:31
 GMT;UgBlADoAIABbAFAAQQBUAEMASAAgADMAMAAvADMAMwBdACAAdgBpAGQAZQBvADoAIABDAG8AbgB2AGUAcgB0ACAAdABvACAAZABlAHYAbQBfAGkAbwByAGUAbQBhAHAAXwByAGUAcwBvAHUAcgBjAGUAKAApAA==
x-cr-puzzleid: {09E18F68-4E95-446B-81AD-61019344EDF1}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+Zvu5roX8BBlsazSxO9H1gtbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkPdvczFbxkr5h7eDNjA+N8ti5GTg4JAROJK9uXMkPY
	YhIX7q0HinNxCAksY5R4OXMvI0zRhDc3WCESixglJh7cxgSSEBL4xShxYjZYkbCAn0TTnElg
	k9gE1CS+fDnMDmKLCIRLbJ6wihmkmVlgHZNE478nLBCTZjFKTJ/fCFbFKRAiMfHWe1aISS4S
	Vxrug01iEVCVWDvhM9g2XgFbie1vr7FB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zFqiXA+hs
	dYlHf3UhjjCSuHBiIVSJiMS+F+8YQW6QEPjDLtG8fAkTxJumEjte7WaBSFxilzi96hErxBEC
	Et8mH2KBGCorsekANLwkJQ6uuMEygVF6FpKTZiE5aRaSk2Yh2b2AkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRkjESu1gXNlgcYhRgINRiYfX4tHfACHWxLLiytxDjBIczEoivP3/gEK8
	KYmVValF+fFFpTmpxYcYk4GOncgsJZqcD0wmeSXxhsbGJmYmpibmlqbmpqQJK4nzMp56EiAk
	kJ5YkpqdmlqQWgSzhYmDU6qBMdkwX+mQ/z4Rv6OKoZP9hRjO/nu0teCE3InOup0WGzf613u+
	8V1/P8Ta4fk22+1iue8CfDy/z657c+SVw0/ZtdniaSnqD33VnQ+1X/n+/f3WFw61diHPfyh9
	a4oKY2vblNffv+XTXwMujdomrW97cnZMuGe/u0NaxaWfI/NV/8qid4wRQcX7lViKMxINtZiL
	ihMB0febYxwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd3XQv8CDC5O0rc40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmPNjdz1Twkr1i
	7uHNjA2M89m6GDk5JARMJCa8ucEKYYtJXLi3HijOxSEksIhRYuLBbUwgCSGBX4wSJ2YzgtjC
	An4STXMmMYPYbAJqEl++HGYHsUUEwiU2T1jFDNLMLLCOSaLx3xMWiEmzGCWmz28Eq+IUCJGY
	eOs9K8QkF4krDffBJrEIqEqsnfAZbBuvgK3E9rfX2CBsQYkfk++xgNjMAloS63ceZ4Kw5SU2
	r3kL1MsBdLa6xKO/uhBHGElcOLEQqkREYt+Ld4wgN0gI/GGXaF6+hAniTVOJHa92s0xgFJ2F
	ZMUsJCtmIVkxC8msBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC08EzqR2MKxssDjEK
	cDAq8fBaPPobIMSaWFZcmXuIUYKDWUmEt/8fUIg3JbGyKrUoP76oNCe1+BBjMjAEJjJLiSbn
	A1NVXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpgPPRQwCeL
	V6HykWBn0fGcqW37pOYsjox6bcgg8Mau/ujz4+2GalX8DsamrB5hLkUvbEqXz7urmtttfWq3
	jtHHBTOXdESs+cpfcSHq6e/5mrWl2wMYT+TMUJ3Ixfy1/+RrhYoNBb32613vdrQf78w9eM3L
	7FPcKWvp4w9ERZvn1Jhc41RMnGWnxFKckWioxVxUnAgAc+u2wEsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 7:09 PM, Thierry wrote
> 
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/exynos/exynos_dp_core.c | 8 +++-----
>  drivers/video/jz4740_fb.c             | 6 +++---
>  drivers/video/omap2/dss/hdmi.c        | 8 +++-----
>  drivers/video/omap2/vrfb.c            | 9 ++++-----
>  drivers/video/s3c-fb.c                | 7 +++----
>  5 files changed, 16 insertions(+), 22 deletions(-)
> 

For drivers/video/s3c-fb.c, drivers/video/exynos/exynos_dp_core.c

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han


