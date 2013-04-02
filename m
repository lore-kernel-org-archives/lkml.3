Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808Ab3DBJuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:50:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59917 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761778Ab3DBJuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:50:52 -0400
X-AuditID: cbfee68d-b7f786d000005188-f8-515aa9e57dbb
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1364637279.1345.115.camel@x61.thuisdomein>
In-reply-to: <1364637279.1345.115.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: S5P64X0: Fix typo "CONFIG_S5P64X0_SETUP_SDHCI"
Date: Tue, 02 Apr 2013 18:50:29 +0900
Message-id: <237901ce2f87$826635b0$8732a110$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4tLJmnAPjf8ivVRi6ob9TPFXUc2wCWt5Zw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI92nK6MCDdq+m1lMWneAyWLT42us
	Fpd3zWGzmHF+H5PF7cu8FotunWF2YPNoae5h8/i76gWzx+Yl9R4btz9h8vi8SS6ANYrLJiU1
	J7MstUjfLoErY++l7WwFj7grehd8YW1gfMjZxcjJISFgInH+13xmCFtM4sK99WxdjFwcQgLL
	GCWaO3YwwRQd+XKRESIxnVHi/ouHrBDOX0aJv88nsoNUsQloSBx+/wzMFhEolti85xpQNwcH
	s0C2xJZXYIOEBMwlFr0/ywhicwpYSDzcsxpss7CAh8Sqzf/BbBYBVYkd/56ygbTyCthK3Dkq
	BhLmFRCU+DH5HgvERHWJKVNyQcLMAvISm9e8ZQYJSwCFH/3VBTFFBIwkbj0TgagQkdj34h3Y
	8RICj9glNk+ZB7VIQOLb5EMsEK2yEpsOQENBUuLgihssExglZiHZOwth7ywke2ch2bCAkWUV
	o2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkic9u5gvH3A+hBjMtD2icxSosn5wDjPK4k3NDYz
	sjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjQZVgqMJprYnf
	pt67kJxVXq3R6vaL08m5e+H91u2vf4ZtU7JMPtV9t/ue6RrmFTHi91mtd9zOdpz/yOaS1L9Z
	GezveDaUyKWsYF3xVrp5w7wf048Ua04qWpHlP2uHv6uozzTBrlcGLAdnzeJKvJLC1qQfw/rg
	EOcu36CojfO5NeaqsWn9knukxFKckWioxVxUnAgARNAfCOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2nK6MCDfYuN7KYtO4Ak8Wmx9dY
	LS7vmsNmMeP8PiaL25d5LRbdOsPswObR0tzD5vF31Qtmj81L6j02bn/C5PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoy9l7azFTziruhd8IW1gfEhZxcjJ4eE
	gInEkS8XGSFsMYkL99azdTFycQgJTGeUuP/iISuE85dR4u/ziewgVWwCGhKH3z8Ds0UEiiU2
	77nG1MXIwcEskC2x5RUTSFhIwFxi0fuzYEM5BSwkHu5ZzQxiCwt4SKza/B/MZhFQldjx7ykb
	SCuvgK3EnaNiIGFeAUGJH5PvsUBMVJeYMiUXJMwsIC+xec1bZpCwBFD40V9dEFNEwEji1jMR
	iAoRiX0v3jFOYBSahWTOLIQ5s5DMmYWkYwEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4CTwTGoH48oGi0OMAhyMSjy8DnMiA4VYE8uKK3MPMUpwMCuJ8G7VjQoU4k1JrKxKLcqPLyrN
	SS0+xJgM9OREZinR5HxggsoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoR
	zBYmDk6pBka1xf0nZr4+eu5i7daXIu4WJse1+wy31r2TVeqoTG2prGw+7nA5tfrxf7H9U/aU
	P/33s6XaNImdycVjQXnhGYVpHM8W6h42EdDUmtMXcjLGzf+YwzkpuzNhP6y3sfV+iROsMlkZ
	ZJdoZPJm1kzTB9x+gvL5CexC7aGz7z+QrvU7qTJ7mvuF10osxRmJhlrMRcWJAGYIJVhGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit ebc433c2890f8ecad2da39fe2dbf2b6e7b309afa ("ARM: S5P64X0: Add
> HSMMC setup for host Controller") added the Kconfig symbol
> S5P64X0_SETUP_SDHCI_GPIO. By accident it also used a macro
> CONFIG_S5P64X0_SETUP_SDHCI. Fix that typo.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Since this typo has been in the tree since v3.3, and some code
> has therefore (basically) been compiled out ever since, this does need
> testing.
> 
>  arch/arm/plat-samsung/include/plat/sdhci.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/sdhci.h b/arch/arm/plat-
> samsung/include/plat/sdhci.h
> index 9b87f38..5560586 100644
> --- a/arch/arm/plat-samsung/include/plat/sdhci.h
> +++ b/arch/arm/plat-samsung/include/plat/sdhci.h
> @@ -206,7 +206,7 @@ static inline void s3c6400_default_sdhci2(void) { }
> 
>  /* S5P64X0 SDHCI setup */
> 
> -#ifdef CONFIG_S5P64X0_SETUP_SDHCI
> +#ifdef CONFIG_S5P64X0_SETUP_SDHCI_GPIO
>  static inline void s5p64x0_default_sdhci0(void)
>  {
>  #ifdef CONFIG_S3C_DEV_HSMMC
> @@ -241,7 +241,7 @@ static inline void s5p64x0_default_sdhci1(void) { }
>  static inline void s5p6440_default_sdhci2(void) { }
>  static inline void s5p6450_default_sdhci2(void) { }
> 
> -#endif /* CONFIG_S5P64X0_SETUP_SDHCI */
> +#endif /* CONFIG_S5P64X0_SETUP_SDHCI_GPIO */
> 
>  /* S5PC100 SDHCI setup */
> 
> --
> 1.7.11.7

Applied, thanks.

- Kukjin

