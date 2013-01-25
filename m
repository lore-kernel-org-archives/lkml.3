Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3AYRvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:51:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40678 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3AYRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:51:08 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-41-5102c60a5dff
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        stable@vger.kernel.org
References: <1359127711-19070-1-git-send-email-arnd@arndb.de>
 <1359127711-19070-4-git-send-email-arnd@arndb.de>
In-reply-to: <1359127711-19070-4-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 3/5] ARM: samsung: fix assembly syntax for new gas
Date: Fri, 25 Jan 2013 09:50:45 -0800
Message-id: <00fb01cdfb24$81fbce10$85f36a30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGCiDLicFoVVu9HOBnjgZIfYqyBugMLl1//mNjbbPA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ12uY0yBBscWyVhc3jWHzWLBxkeM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX87HzDWPBapmLRnAamBsZPEl2MnBwSAiYS89ftZoWw
	xSQu3FvP1sXIxSEksIxRYv+yuywwRY+vgBSBJBYxSiw7dxHK+cso8fznf3aQKjYBDYnD75+B
	2SICnhJnTi4A6ubgYBaIlZgwJQokLCRQKHG64xHYUE4BO4nzO+8ygdjCAm4SO+5/BbNZBFQl
	nixexgTSyitgKdE1VR8kzCsgKPFj8j2wVmYBLYn1O48zQdjyEpvXvGWGuFNBYsfZ14wQF1hJ
	tO1vZIOoEZeY9OAhO8jJEgLr2CUO7zjKDLFLQOLb5ENgZ0oIyEpsOgA1R1Li4IobLBMYJWYh
	WT0LyepZSFbPQrJiASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQGJPewbiqweIQowAH
	oxIP74e5TIFCrIllxZW5hxglOJiVRHhlTIBCvCmJlVWpRfnxRaU5qcWHGJOBjp3ILCWanA+M
	/7ySeENjYxMzE1MTc0tTc1PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwDh1U/FBC7nG
	A7VFfPuCS5ZoJk3JTggVW7+5RTiGWeWOrhLzjSmFEVq7V54ImWMzceHN3Udr/OL+Rf5P2BR8
	fWqlpOXRVdZW579u9az51VjP0BhUWnpiWsTduaItbCvkWtV7jCU2uPobxPhNCJqn5pTV81WP
	9ds0Xm+FW8bSBZ7dm/aV1zx2VGIpzkg01GIuKk4EAOfAFBL1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV2uY0yBBr/Oillc3jWHzWLBxkeM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/Ox8w1jwWqZi
	0ZwGpgbGTxJdjJwcEgImEo+v7GaFsMUkLtxbz9bFyMUhJLCIUWLZuYusEM5fRonnP/+zg1Sx
	CWhIHH7/DMwWEfCUOHNyAUsXIwcHs0CsxIQpUSBhIYFCidMdj1hAbE4BO4nzO+8ygdjCAm4S
	O+5/BbNZBFQlnixexgTSyitgKdE1VR8kzCsgKPFj8j2wVmYBLYn1O48zQdjyEpvXvGWGuFNB
	YsfZ14wQF1hJtO1vZIOoEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREcwc+kdzCuarA4xCjAwajEw/thLlOgEGtiWXFl7iFGCQ5mJRFeGROg
	EG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDk0teSbyhsYmZkaWRmYWRibk5acJK4ryMp54E
	CAmkJ5akZqemFqQWwWxh4uCUamDMD+S43t0ryHlQh+3jWyexmJIrU9p2LG15abZAQtPAkOGJ
	3EOfyIfJUvvjxH5/ernrqMCfY5bFChMY1RSFS3/Nnb5v89v5bYF3TA/dvfeqOtp0QtDKpCLB
	G5v8bwgwJ7H5MIpcF9sW9KJzVXvFte/q+3+URoks/aX/wFQ96PrPPIWdFhZR1/SUWIozEg21
	mIuKEwGiPNzCJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Recent assembler versions complain about extraneous
> whitespace inside [] brackets. This fixes all of
> these instances for the samsung platforms. We should
> backport this to all kernels that might need to
> be built with new binutils.
> 
> arch/arm/kernel/entry-armv.S: Assembler messages:
> arch/arm/kernel/entry-armv.S:214: Error: ARM register expected -- `ldr
> r2,[ r6,#(0x10)]'
> arch/arm/kernel/entry-armv.S:214: Error: ARM register expected -- `ldr
> r0,[ r6,#(0x14)]'
> arch/arm/kernel/entry-armv.S:430: Error: ARM register expected -- `ldr
> r2,[ r6,#(0x10)]'
> arch/arm/kernel/entry-armv.S:430: Error: ARM register expected -- `ldr
> r0,[ r6,#(0x14)]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S: Assembler messages:
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:48: Error: ARM register expected --
> `ldr r7,[ r4 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:49: Error: ARM register expected --
> `ldr r8,[ r5 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:50: Error: ARM register expected --
> `ldr r9,[ r6 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:64: Error: ARM register expected --
> `streq r7,[ r4 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:65: Error: ARM register expected --
> `streq r8,[ r5 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2410.S:66: Error: ARM register expected --
> `streq r9,[ r6 ]'
> arch/arm/kernel/debug.S: Assembler messages:
> arch/arm/kernel/debug.S:83: Error: ARM register expected -- `ldr
> r2,[ r2,#((0x0B0)+(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000))))-((0)+(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000))))]'
> arch/arm/kernel/debug.S:83: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x18)]'
> arch/arm/kernel/debug.S:85: Error: ARM register expected -- `ldr
> r2,[ r2,#((0x0B0)+(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000))))-((0)+(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000))))]'
> arch/arm/kernel/debug.S:85: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x18)]'
> arch/arm/mach-s3c24xx/pm-h1940.S: Assembler messages:
> arch/arm/mach-s3c24xx/pm-h1940.S:33: Error: ARM register expected -- `ldr
> pc,[ r0,#((0x0B8)+(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000))))-(((0x56000000)-
> (0x50000000))+(0xF6000000+(0x01000000)))]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S: Assembler messages:
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:60: Error: ARM register expected --
> `ldrne r9,[ r1 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:61: Error: ARM register expected --
> `strne r9,[ r1 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:62: Error: ARM register expected --
> `ldrne r9,[ r2 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:63: Error: ARM register expected --
> `strne r9,[ r2 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:64: Error: ARM register expected --
> `ldrne r9,[ r3 ]'
> arch/arm/mach-s3c24xx/sleep-s3c2412.S:65: Error: ARM register expected --
> `strne r9,[ r3 ]'
> arch/arm/kernel/debug.S:83: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x08)]'
> arch/arm/kernel/debug.S:83: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x18)]'
> arch/arm/kernel/debug.S:83: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x10)]'
> arch/arm/kernel/debug.S:85: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x08)]'
> arch/arm/kernel/debug.S:85: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x18)]'
> arch/arm/kernel/debug.S:85: Error: ARM register expected -- `ldr
> r2,[ r3,#(0x10)]'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

[...]

Thanks.

- Kukjin

