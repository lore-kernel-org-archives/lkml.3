Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaKSB0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:26:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29481 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbaKSB0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:26:32 -0500
X-AuditID: cbfee68d-f79296d000004278-c1-546bf1c604c4
Message-id: <546BF1C5.3050000@samsung.com>
Date: Wed, 19 Nov 2014 10:26:29 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: dw_mmc: Add support for IMG Pistachio
References: <1415904621-26800-1-git-send-email-abrestic@chromium.org>
 <CAD=FV=WZx6r5L76Bfn2L8WeSU4hKwNJ=tZq_FoT3ot1Hd2ToeQ@mail.gmail.com>
In-reply-to: <CAD=FV=WZx6r5L76Bfn2L8WeSU4hKwNJ=tZq_FoT3ot1Hd2ToeQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkRPfYx+wQg0e3eSxWvv/LaDHh8nZG
	i7PLDrJZnHi+iM3i3Ief7BaXd81hszjyv5/R4sP9i8wWx9eGO3B6zG64yOLRs/MMo8eda3vY
	PG68Wsjk0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBmt/16xFKxhq2i7oNjA2MjaxcjJISFg
	IrFizyU2CFtM4sK99UA2F4eQwFJGiQ/9W9lhig78P8sEkZjOKHHoy3kWkISQwGtGiRutmV2M
	HBy8AloSzXfCQMIsAqoSl9bdAOtlE9CR2P7tOBOILSoQJnGobR6YzSsgKPFj8j0WkFYRoHjz
	tSqQ8cwCx5kk7vRdYgapERawl3jy/DUzxN4eRonbcy+DDeUUCJY4/74RbBCzgLrEpHmLmCFs
	eYnNa94yQxz9iF3i/C8tiIMEJL5NPgS2TEJAVmLTAagSSYmDK26wTGAUm4XkpFlIps5CMnUB
	I/MqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjMB4PP3vWe8OxtsHrA8xCnAwKvHwvnibHSLE
	mlhWXJl7iNEU6IqJzFKiyfnAqM8riTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoFx4bbTMz2719b9O7bd/Ww4i2vio3v2vtwbN01anrmdsyTkidVshabj
	7IcYtyZtUOWZVS/Jwi7Cya7VVCUm63b/y6MFSW8vLFV/snjrAsESWZUwySdWyuph0TetbQX7
	Kw9vKc0Om9Z6coqvef+Pb2fdWu+zxj2Y3vhI+KT2yUlTV276+qHHR1dCiaU4I9FQi7moOBEA
	cDfn5cICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd1jH7NDDF4vYbVY+f4vo8WEy9sZ
	Lc4uO8hmceL5IjaLcx9+sltc3jWHzeLI/35Giw/3LzJbHF8b7sDpMbvhIotHz84zjB53ru1h
	87jxaiGTR9+WVYwenzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM
	aP33iqVgDVtF2wXFBsZG1i5GTg4JAROJA//PMkHYYhIX7q1n62Lk4hASmM4ocejLeRaQhJDA
	a0aJG62ZXYwcHLwCWhLNd8JAwiwCqhKX1t1gB7HZBHQktn87DjZHVCBM4lDbPDCbV0BQ4sfk
	eywgrSJA8eZrVSDjmQWOM0nc6bvEDFIjLGAv8eT5a2aIvT2MErfnXgYbyikQLHH+fSPYIGYB
	dYlJ8xYxQ9jyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjON6fSe9gXNVgcYhRgINRiYc3cWpWiBBrYllxZe4hRgkOZiURXsHu7BAh3pTEyqrUovz4
	otKc1OJDjKbAIJjILCWanA9MRXkl8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KL
	YPqYODilGhjZAlxz/H7Y2oum7zlbtuxTRsXHU3ue5O8rO1NTdXt9t4XB5ufNJpNdRY31FTND
	9uX8Oeb4z6AlSitoVcWvBusDqtbPwmdaPe2U1qqc1PVSaHe0pxbP9CxJ5qJHde1iR5WCDZYu
	vFTp0nU3Za2ge5XRPn4lGSUpNeZdzb4LCnlsGK4pzZqho8RSnJFoqMVcVJwIABlUcXoNAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 02:28 AM, Doug Anderson wrote:
> Andrew,
> 
> On Thu, Nov 13, 2014 at 10:50 AM, Andrew Bresticker
> <abrestic@chromium.org> wrote:
>> Add support for the DW MMC host found on the Imagination Pistachio SoC.
>> Like the DW MMC hosts found on SOCFPGA and Rockchip SoCs, the DW MMC
>> host on Pistachio requires the use of SDMMC_CMD_USE_HOLD_REG.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  .../devicetree/bindings/mmc/img-dw-mshc.txt        | 29 ++++++++++++++++++++++
>>  drivers/mmc/host/dw_mmc-pltfm.c                    |  6 +++++
>>  2 files changed, 35 insertions(+)
> 
> This seems quite sane to me.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung
> 

