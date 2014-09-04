Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaIDFGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:06:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30460 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaIDFGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:06:47 -0400
X-AuditID: cbfee68d-f79c46d000000b84-23-5407f3654104
Message-id: <5407F364.9030303@samsung.com>
Date: Thu, 04 Sep 2014 14:06:44 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, Georgi Djakov <gdjakov@mm-sol.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
References: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>
In-reply-to: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkRDf1M3uIwbWp3BZ7206wW0y4vJ3R
	ouHTHVaLTY+vsVpM3H+W3eLyrjlsFkf+9zNa/DjTzWJxfG24xazjH9kcuDwu9/Uyedy5tofN
	Y/OSeo9N+6cxe9x4tZDJ4/MmuQC2KC6blNSczLLUIn27BK6M5T8mMxeck6vYekiogbFdsouR
	k0NCwETiZ/NURghbTOLCvfVsXYxcHEICSxklzq9+w9zFyAFWdGS+EkiNkMAiRonVi+sgal4z
	Sjw8P4MFJMEroCVxac4fdhCbRUBVYuqD62A2m4COxPZvx5lAbFGBMIlDbfOYIOoFJX5MvgfW
	KyLgK/Hxwi6wxcwCi5gkjh67wAySEBbwkfja2soOsdlZ4ta2yawgNqeAi8S+K6/AmpmBFuxv
	ncYGYctLbF7zlhlkkITAS3aJu7+eMENcJCDxbfIhFohvZCU2HWCG+FhS4uCKGywTGMVmIblp
	FpKxs5CMXcDIvIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMDJP/3vWu4Px9gHrQ4wCHIxK
	PLwFL9hDhFgTy4orcw8xmgJdMZFZSjQ5Hxj/eSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MKo0W2U4PZOcL3P/mWnR5GlrbiUl+54zkLXdKvX/zNVz
	e5gy3/gwTLAx7zdbsPKz4BqVPF4Zi/X22jdSFxmdmvLYY2mUss2F06z6QkKfa+zlgqbsY0i4
	F5qTKPU3ztn//ozfHOfmWU49nJfQeXvn2ZoZxhfUHhvkTjBT1m1gOtH/R4nbPn+6vhJLcUai
	oRZzUXEiAAEwoorHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jAd3Uz+whBu3zmS32tp1gt5hweTuj
	RcOnO6wWmx5fY7WYuP8su8XlXXPYLI7872e0+HGmm8Xi+Npwi1nHP7I5cHlc7utl8rhzbQ+b
	x+Yl9R6b9k9j9rjxaiGTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM5b/mMxccE6uYushoQbGdskuRg4OCQETiSPzlboYOYFMMYkL99azgdhCAosYJVYvruti
	5AKyXzNKPDw/gwUkwSugJXFpzh92EJtFQFVi6oPrYDabgI7E9m/HmUBsUYEwiUNt85gg6gUl
	fky+B9YrIuAr8fHCLjaQocwCi5gkjh67wAySEBbwkfja2soOsdlZ4ta2yawgNqeAi8S+K6/A
	mpmBFuxvncYGYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzguH8mtYNxZYPFIUYBDkYlHt6CF+whQqyJZcWVuYcYJTiYlUR4Z58FCvGmJFZWpRbl
	xxeV5qQWH2I0BQbBRGYp0eR8YErKK4k3NDYxM7I0Mje0MDI2VxLnPdBqHSgkkJ5YkpqdmlqQ
	WgTTx8TBKdXA6Mt84vqOIMW5zf7Hz2npymhLLdxza8bz5/kBF92Nfja2fj54K8YizX9i7MnU
	nISoKU+Ozvq5q8Tts9jydR37vfK2ML07Hl/Xsk6CZSXbR86rMvonsnPN9h3LKV2W8yM+4ijj
	+qXJnt/Ohhd62G9J3CszZUtTMoPmAnOfu/ZMPN62iS+5D7jeVGIpzkg01GIuKk4EAEA2C8UR	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen.

On 09/03/2014 10:57 PM, Stephen Boyd wrote:
> If we're tuning on a big-endian CPU we'll never determine we properly
> tuned the device because we compare the data we received from the
> controller with a table that assumes the CPU is little-endian.
> Change the table to be an array of bytes instead of 32-bit words
> so we can use memcmp() without needing to byte-swap every word
> depending on the endianess of the CPU.
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Reviewed-by: Georgi Djakov <gdjakov@mm-sol.com>
> Fixes: 415b5a75da43 "mmc: sdhci-msm: Add platform_execute_tuning implementation"
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mmc/host/sdhci-msm.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 40573a58486a..5aabffc15ae8 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -47,22 +47,34 @@
>  #define CMUX_SHIFT_PHASE_SHIFT	24
>  #define CMUX_SHIFT_PHASE_MASK	(7 << CMUX_SHIFT_PHASE_SHIFT)
>  
> -static const u32 tuning_block_64[] = {
> -	0x00ff0fff, 0xccc3ccff, 0xffcc3cc3, 0xeffefffe,
> -	0xddffdfff, 0xfbfffbff, 0xff7fffbf, 0xefbdf777,
> -	0xf0fff0ff, 0x3cccfc0f, 0xcfcc33cc, 0xeeffefff,
> -	0xfdfffdff, 0xffbfffdf, 0xfff7ffbb, 0xde7b7ff7
> +static const u8 tuning_block_64[] = {
> +	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
> +	0xc3, 0x3c, 0xcc, 0xff, 0xfe, 0xff, 0xfe, 0xef,
> +	0xff, 0xdf, 0xff, 0xdd, 0xff, 0xfb, 0xff, 0xfb,
> +	0xbf, 0xff, 0x7f, 0xff, 0x77, 0xf7, 0xbd, 0xef,
> +	0xff, 0xf0, 0xff, 0xf0, 0x0f, 0xfc, 0xcc, 0x3c,
> +	0xcc, 0x33, 0xcc, 0xcf, 0xff, 0xef, 0xff, 0xee,
> +	0xff, 0xfd, 0xff, 0xfd, 0xdf, 0xff, 0xbf, 0xff,
> +	0xbb, 0xff, 0xf7, 0xff, 0xf7, 0x7f, 0x7b, 0xde,
>  };
>  
> -static const u32 tuning_block_128[] = {
> -	0xff00ffff, 0x0000ffff, 0xccccffff, 0xcccc33cc,
> -	0xcc3333cc, 0xffffcccc, 0xffffeeff, 0xffeeeeff,
> -	0xffddffff, 0xddddffff, 0xbbffffff, 0xbbffffff,
> -	0xffffffbb, 0xffffff77, 0x77ff7777, 0xffeeddbb,
> -	0x00ffffff, 0x00ffffff, 0xccffff00, 0xcc33cccc,
> -	0x3333cccc, 0xffcccccc, 0xffeeffff, 0xeeeeffff,
> -	0xddffffff, 0xddffffff, 0xffffffdd, 0xffffffbb,
> -	0xffffbbbb, 0xffff77ff, 0xff7777ff, 0xeeddbb77
> +static const u8 tuning_block_128[] = {
> +	0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00,
> +	0xff, 0xff, 0xcc, 0xcc, 0xcc, 0x33, 0xcc, 0xcc,
> +	0xcc, 0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xff, 0xff,
> +	0xff, 0xee, 0xff, 0xff, 0xff, 0xee, 0xee, 0xff,
> +	0xff, 0xff, 0xdd, 0xff, 0xff, 0xff, 0xdd, 0xdd,
> +	0xff, 0xff, 0xff, 0xbb, 0xff, 0xff, 0xff, 0xbb,
> +	0xbb, 0xff, 0xff, 0xff, 0x77, 0xff, 0xff, 0xff,
> +	0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee, 0xff,
> +	0xff, 0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x00,
> +	0x00, 0xff, 0xff, 0xcc, 0xcc, 0xcc, 0x33, 0xcc,
> +	0xcc, 0xcc, 0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xff,
> +	0xff, 0xff, 0xee, 0xff, 0xff, 0xff, 0xee, 0xee,
> +	0xff, 0xff, 0xff, 0xdd, 0xff, 0xff, 0xff, 0xdd,
> +	0xdd, 0xff, 0xff, 0xff, 0xbb, 0xff, 0xff, 0xff,
> +	0xbb, 0xbb, 0xff, 0xff, 0xff, 0x77, 0xff, 0xff,
> +	0xff, 0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee,
>  };
In dw-mmc.c, tuning_block values are same.
So I think we can move these value into generic header. how about?

Best Regards,
Jaehoon Chung

>  
>  struct sdhci_msm_host {
> @@ -359,7 +371,7 @@ static int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
>  {
>  	int tuning_seq_cnt = 3;
>  	u8 phase, *data_buf, tuned_phases[16], tuned_phase_cnt = 0;
> -	const u32 *tuning_block_pattern = tuning_block_64;
> +	const u8 *tuning_block_pattern = tuning_block_64;
>  	int size = sizeof(tuning_block_64);	/* Pattern size in bytes */
>  	int rc;
>  	struct mmc_host *mmc = host->mmc;
> 

