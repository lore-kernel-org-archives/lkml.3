Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3KDJ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:57:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65175 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3KDJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:56:59 -0500
X-AuditID: cbfee691-b7f866d000001b8c-38-52776f6af792
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1383558685-5343-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1383558685-5343-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] ARM: SAMSUNG: remove unused SAMSUNG_GPIOLIB_4BIT Kconfig
 parameter
Date: Mon, 04 Nov 2013 18:56:57 +0900
Message-id: <000001ced944$33386320$99a92960$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7ZQ3zKWiJDrGp+TRyvibs27yfMkQAAFa4g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zI92s/PIgg33f+C0mrTvAZHF54SVW
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvxYMIqNgcOj5bmHjaPv6teMHs82XSR0WPzknqP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgylh59iZbQQNLxc1LU9kaGKcwdzFyckgImEj8/HmN
	EcIWk7hwbz1bFyMXh5DAMkaJc3d+MMEULf/bCNYgJLCIUWLr5XqIol+MEutmXwXrZhNQk/jy
	5TB7FyMHh4iAg8T/DyYgNcwCXxglNm2ZzgYSFxIIk3h1qgqknFMgXOLA2iOsILawQKTErwPP
	wcawCKhKLF66kR3E5hWwlbi/7zqULSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmUHGSwioSzz6
	qwsSFhEwknh48ykrRImIxL4X7xhBzpEQaOSQ+HF5PwvELgGJb5MPsUD0ykpsOgANE0mJgytu
	sExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFCYnniDsb7
	B6wPMSYDrZ/ILCWanA9MBXkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwGivcrrrSa1zd0bQ5TbbdTrn+GdXSqvGtHrtPuP6erPPAeM4VmvVNO3M
	Q/F7Vt2P391zyvZrp39YTP4F2y1bq/WZNV4qFmzL5Jy9bOPrNabflAxSLtWVv19geSyCoafk
	djVfaNDDiT2tS9zETv8966Zb23JIK+lyWdKuwk+SCSf+s7nzNMu3KLEUZyQaajEXFScCAPWb
	Oxj7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd2s/PIgg9Yb3BaT1h1gsri88BKr
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rV4MGEVmwOHR0tzD5vH31UvmD2ebLrI6LF5Sb1H
	35ZVjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xYefYmW0ED
	S8XNS1PZGhinMHcxcnJICJhILP/bCGWLSVy4t54NxBYSWMQosfVyfRcjF5D9i1Fi3eyrjCAJ
	NgE1iS9fDrN3MXJwiAg4SPz/YAJSwyzwhVFi05bpbCBxIYEwiVenqkDKOQXCJQ6sPcIKYgsL
	REr8OvAcbAyLgKrE4qUb2UFsXgFbifv7rkPZghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWS8
	hIC6xKO/uiBhEQEjiYc3n7JClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIThTPpHYwrmywOMQowMGoxMMrcbksSIg1say4MvcQowQHs5II
	L0NYeZAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wOTWF5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdarQOFBNITS1KzU1MLUotgtjBxcEo1MNZcCL978NyCh5I8EyeetAx+1i8W/f7EoYk/3qgs
	+xmrwGyUUzsz0t+P/fMKZve12asOWHyPOiCh1brXdkNMuaRL+dKyjhX8LFKCH52/hovXPN4h
	5Jt656d+4JvCxo8dswTWXZ214ec7txuS17ZLJfHwrvqnGjFvb03+K/mCYD2TT17rD+6ZHafE
	UpyRaKjFXFScCADqfYSBWAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 04, 2013 6:51 PM, Michael Opdenacker wrote:
> 
> This removes the SAMSUNG_GPIOLIB_4BIT Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  arch/arm/Kconfig              | 1 -
>  arch/arm/plat-samsung/Kconfig | 8 --------
>  2 files changed, 9 deletions(-)

