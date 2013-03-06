Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CFXs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:48:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26116 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3CFXs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:48:26 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-43-5137d5c96ac5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-8-git-send-email-arnd@arndb.de>
In-reply-to: <1362521809-22989-8-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 7/9] [media] s5p-fimc: fix s5pv210 build
Date: Thu, 07 Mar 2013 08:48:25 +0900
Message-id: <013101ce1ac5$17e9f090$47bdd1b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Z7yUPGF/F45zeSQiKVnIWECPHNgAN9X7g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd2TV80DDVoPK1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MhTO7WAsmcle0/QloYOzn7GLk5JAQMJFY1fuLEcIWk7hwbz1b
	FyMXh5DAMkaJp89XscEUXbiymgUisYhR4tylKUwQzjwmiZZrr1lBqtgENCQOv3/GDmKLCDhK
	LHz+lBWkiFngBKPE549HmUASQgKFEncmrQcr4hSwk3hyYSHQbg4OYQEbiW2LuUDCLAKqErfX
	LGAGCfMK2Eq8PwMW5hUQlPgx+R4LiM0soCWxfudxJghbXmLzmrdg5RIC6hKP/uqCmCICRhLv
	9olDVIhI7HvxjhHkGAmBVewSG273MUNsEpD4NvkQC0SrrMSmA8wQ70pKHFxxg2UCo8QsJItn
	IVk8C8niWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRElUTdzDeP2B9iDEZaP1E
	ZinR5HxgVOaVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA6PZr5PLYw79+lGqvTn5xI59hvK3bbfvck93283Jp+ZrKevA6vHn4V8bzU9LTX5qb/CK
	/fI2TFf+t2XZEw6r/6U1Ub4HRd/yXuy48nweu9kGpk08GheWhUsk5DnyXrtgc6Wl9nZD3dHC
	iXe3f3zQX/iveFLyy6cNLTOmcHT5m9XybjVdr17NLKHEUpyRaKjFXFScCAD2hJiewAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7Jq+aBBudny1pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIUzu1gLJnJXtP0JaGDs
	5+xi5OSQEDCRuHBlNQuELSZx4d56ti5GLg4hgUWMEucuTWGCcOYxSbRce80KUsUmoCFx+P0z
	dhBbRMBRYuHzp6wgRcwCJxglPn88ygSSEBIolLgzaT1YEaeAncSTCwsZuxg5OIQFbCS2LeYC
	CbMIqErcXrOAGSTMK2Ar8f4MWJhXQFDix+R7YAcxC2hJrN95nAnClpfYvOYtWLmEgLrEo7+6
	IKaIgJHEu33iEBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgmP2mdQOxpUNFocYBTgYlXh4OfLNA4VYE8uKK3MPMUpwMCuJ8N5dAhTiTUms
	rEotyo8vKs1JLT7EmAz05kRmKdHkfGA6ySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTE
	ktTs1NSC1CKYLUwcnFINjHq3bl9jW/Go+9G1bcW6ST/O7/t8+bWQ0ab5M+umP8uTvH99y+MO
	v5O2Li+tH4s+t/ONaWWdK2Rt6/mCdfGkQN4ZGsd8OG/8Lr+wp7ngld+UuxyScmqNouLrr89Z
	Yhuj3Tt1BQ9HQdTuNTfzWKxu6uY0Xp6cEWTAyrmwwqtSsP1fntWyNa+3MyqxFGckGmoxFxUn
	AgAntsLVHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> 56bc911 "[media] s5p-fimc: Redefine platform data structure for fimc-is"
> changed the bus_type member of struct fimc_source_info treewide, but
> got one instance wrong in mach-s5pv210, which was evidently not
> even build tested.
> 
> This adds the missing change to get s5pv210_defconfig to build again.
> Applies on the Mauro's media tree.
> 
I'm fine if this can be fixed soon.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  arch/arm/mach-s5pv210/mach-goni.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-
> s5pv210/mach-goni.c
> index 3a38f7b..e373de4 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -845,7 +845,7 @@ static struct fimc_source_info goni_camera_sensors[]
> = {
>  		.mux_id		= 0,
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_BUS_TYPE_ITU_601,
> +		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
>  		.board_info	= &noon010pc30_board_info,
>  		.i2c_bus_num	= 0,
>  		.clk_frequency	= 16000000UL,
> --
> 1.8.1.2

