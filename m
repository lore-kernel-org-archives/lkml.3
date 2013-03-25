Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3CYBIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:08:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38755 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3CYBIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:08:39 -0400
X-AuditID: cbfee690-b7f656d0000007e3-c3-514fa396f4d7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363778011.1390.96.camel@x61.thuisdomein>
In-reply-to: <1363778011.1390.96.camel@x61.thuisdomein>
Subject: RE: [PATCH] S3C24XX: remove unneeded "config SMDK2440_CPU2442"
Date: Mon, 25 Mar 2013 10:08:38 +0900
Message-id: <16e201ce28f5$4870be90$d9523bb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4lW/YDHb92UaQlRMWxrZYtv6bPCwBiEzuw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ91pi/0DDXZPs7KYtO4Ak8Wmx9dY
	LS7vmsNmMeP8PiaL25d5LRbdOsPswObR0tzD5vF31Qtmj81L6j02bn/C5PF5k1wAaxSXTUpq
	TmZZapG+XQJXxoTW9awFXzkr1h3YytjA+IG9i5GTQ0LARGLe2T4mCFtM4sK99WxdjFwcQgLL
	GCX+zkEoOnl5IStEYjqjxLdLj9khnL+MEk9uz2cFqWIT0JA4/P4ZWIeIQLHE5j3XgMZycDAL
	ZEtseQW2QUjATGLJn/csIDangLnE1HtH2UBsYQF3ia5FZ8DiLAKqEvu2PQAbwytgK7Fz4iM2
	CFtQ4sfkeywQI9UlpkzJBQkzC8hLbF7zlhkkLAEUfvRXF+IAI4k9344zQpSISOx78Y4R5GIJ
	gXvsEu+XT2WGWCUg8W3yIRaIXlmJTQeYId6VlDi44gbLBEaJWUgWz0JYPAvJ4llINixgZFnF
	KJpakFxQnJReZKJXnJhbXJqXrpecn7uJERKrE3Yw3jtgfYgxGWj7RGYp0eR8YKznlcQbGpsZ
	WZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRiYfndqVAVoPN
	5jO8J066rdAy1V+db91h/YRHi1c+8fyUg2FL5/JdZLTZ4ianL8d9/qnquvfaWo5NRYYO697+
	tzU5JZvILBLy8Mcj0ZuKHtzFzx+ladvkzl93Ylful/1qgn16fPLXL1dOS3D0vCZ9qnXL3/U3
	gyvtrN/99uMMeOoSZNp3q1GJpTgj0VCLuag4EQA5Ljc46wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd1pi/0DDf6tNrOYtO4Ak8Wmx9dY
	LS7vmsNmMeP8PiaL25d5LRbdOsPswObR0tzD5vF31Qtmj81L6j02bn/C5PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xowJretZC75yVqw7sJWxgfEDexcjJ4eE
	gInEycsLWSFsMYkL99azdTFycQgJTGeU+HbpMTuE85dR4snt+WBVbAIaEoffPwPrFhEolti8
	5xpTFyMHB7NAtsSWV0wgYSEBM4klf96zgNicAuYSU+8dZQOxhQXcJboWnQGLswioSuzb9gBs
	DK+ArcTOiY/YIGxBiR+T77FAjFSXmDIlFyTMLCAvsXnNW2aQsARQ+NFfXYgDjCT2fDvOCFEi
	IrHvxTvGCYxCs5AMmoUwaBaSQbOQdCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwI
	nkntYFzZYHGIUYCDUYmHV6DGP1CINbGsuDL3EKMEB7OSCO+CfqAQb0piZVVqUX58UWlOavEh
	xmSgNycyS4km5wOTVF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBx
	cEo1MFrYXWx4dIq1r/9/ulTLxMmqAjEz26cvWlBx6JXssiNdqsG+17aJq1mtZ62qaGZn/zRn
	7kdHlxez2ipfWywoYm/1nGB6/nD7lymX+/kD9gdodIUGCdbPW3aOYcvWts0a61sTvffdEbqf
	vaVkScl6jfsum9ZfdC1pCRNTLORfusslfkJLX4yyvRJLcUaioRZzUXEiAEjXkQNIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The Kconfig entry for SMDK2440_CPU2442 was moved from one Kconfig file
> to another in commit acf2d41d8595829eb0ac7bf6891f4875a78d4d6e ("ARM:
> S3C24XX: Move mach-s3c2440/ pll into mach-s3c24xx/"). In that move it
> also lost its statement to select CPU_S3C2442. That was not needed
> anymore because it now depended on that same symbol.
> 
> But without its select this entry became a nop: enabling it has no
> effect, as it changes no code. It can safely be removed.
> 
> Fix a related, and trivial, comment typo too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  arch/arm/mach-s3c24xx/Kconfig | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 37f513d..92c07a2 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -663,10 +663,7 @@ config MACH_RX1950
>  	help
>  	   Say Y here if you're using HP iPAQ rx1950
> 
> -config SMDK2440_CPU2442
> -	bool "SMDM2440 with S3C2442 CPU module"
> -
> -endif	# CPU_S3C2440
> +endif	# CPU_S3C2442
> 
>  if CPU_S3C2443 || CPU_S3C2416
> 
> --
> 1.7.11.7

Looks good to me, applied.

Thanks.

- Kukjin

