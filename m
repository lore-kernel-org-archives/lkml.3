Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3HFBQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:16:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42662 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3HFBQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:16:33 -0400
X-AuditID: cbfee68e-b7f276d000002279-9c-52004e6fbc86
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Stephen Warren'" <swarren@wwwdotorg.org>,
        "'Ian Campbell'" <ian.campbell@citrix.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
Subject: Re: [PATCH RESEND] ARM: dts: Add USB host node for Exynos4
Date: Tue, 06 Aug 2013 10:16:31 +0900
Message-id: <000801ce9242$95848570$c08d9050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFpxjNmC74AZn5UM4QqjAUygih++JpQ+HKQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t8zI918P4Ygg59/rSzmHznHavGmt4PF
	4vLCS6wWvQuusllsenyN1eLyrjlsFjPO72OyuH2Z12Lp9YtMFhOmr2WxOLziAJPFq4NtLBb7
	Hq9hduD1WDNvDaNHS3MPm8eCz1fYPV5PnsDosXPWXXaPzUvqPfq2rGL0+LxJzmPj3NAAzigu
	m5TUnMyy1CJ9uwSujKtbjrIW/GaqOHWmh7GBcR1TFyMnh4SAicT9N3vYIGwxiQv31gPZXBxC
	AssYJY4uWcgKU3T21B8miMR0Roknm9YyQji/GCU2n1gLVsUmoCbx5cthdhBbBMhu/NvJClLE
	LHCaWeJg5xsWkISQgJPE9eN/wWxOAWeJB6fXM4PYwkD29d1XGUFsFgFViTNTloLdxytgKTH9
	ficLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvmSFOVZDYcfY1I8QRRhJ/D3xkh6gRkdj34h3Y
	1RICWzgkdqz+AbVMQOLb5ENAQzmAErISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDI
	sopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJEH07WC8ecD6EGMy0PqJzFKiyfnABJNXEm9o
	bGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZehr1Ka8Vy
	nJqYOzcc33yrmb/dstVu89tb+2Zu5MpiY5vps8s4IePWfZMW5gP9uYypCu3c3UsYbtm2My7Z
	bKL2yXvxxxKH6h8xsmt1LuwwjLdbXDe1eA/H9JeqDCqTn7tUt5sLlzVoLf7ydZ+Uckp87o8u
	naDAH1k5QXMeCh/WE8/J/bAzRYmlOCPRUIu5qDgRAFBTJB0mAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t9jQd18P4Ygg60NZhbzj5xjtXjT28Fi
	cXnhJVaL3gVX2Sw2Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYHF5xgMni1cE2Fot9
	j9cwO/B6rJm3htGjpbmHzWPB5yvsHq8nT2D02DnrLrvH5iX1Hn1bVjF6fN4k57FxbmgAZ1QD
	o01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0NlKCmWJ
	OaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyrW46yFvxmqjh1poexgXEdUxcj
	J4eEgInE2VN/oGwxiQv31rN1MXJxCAlMZ5R4smktI4Tzi1Fi84m1rCBVbAJqEl++HGYHsUWA
	7Ma/nawgRcwCp5klDna+YQFJCAk4SVw//hfM5hRwlnhwej0ziC0MZF/ffZURxGYRUJU4M2Up
	2GpeAUuJ6fc7WSBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMcaqCxI6zrxkhjjCS+HvgIztE
	jYjEvhfvGCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	9PNMegfjqgaLQ4wCHIxKPLwJV/8HCrEmlhVX5h5ilOBgVhLh7eRmCBLiTUmsrEotyo8vKs1J
	LT7EmAz06URmKdHkfGBqzCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGxto/q+4+PtR1S1uiir1fvifyurH92ZNLHvzW4NmgKvN17X7PpSfqjohrvZp2aeZW
	/mrWqAQ31u+vnu3+fGzSN/ZXq6IFd/2sEj8b4D5lqffEw88XaR6Q9Mo7/9XDuYFzg0H8+uUT
	ZnJ/3id1MNGVq2NOOO9P6w/bep7LPKp5d3DlxTR/t7/Fk88qsRRnJBpqMRcVJwIABmRy24MD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 3:09 AM, Dongjin Kim wrote:
> 
> This patch adds EHCI and OHCI host device nodes for Exynos4.
> 
> CC: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>


> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)


