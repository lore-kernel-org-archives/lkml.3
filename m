Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaFYL33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:29:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59916 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaFYL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:29:26 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-84-53aab294176b
Message-id: <53AAB27D.3030409@samsung.com>
Date: Wed, 25 Jun 2014 13:29:01 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        mturquette@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: s3c64xx: Hookup SPI clocks correctly
References: <1403085143-3257-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1403085143-3257-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7pTNq0KNtjw08ri35Qb7BaXd81h
	s5hxfh+TxdMJF9kcWDzuXNvD5vFy4m82j8+b5AKYo7hsUlJzMstSi/TtErgyNp3ZyFxwjK3i
	YPcs9gbGWaxdjJwcEgImEkvX/mKEsMUkLtxbz9bFyMUhJLCUUWLyhJ3sEM5nRon+lotMIFW8
	AloSFy+9BLNZBFQl+i/9Zgax2QTUJD43PGIDsfmBatY0XWfpYuTgEBWIkHh8QQiiVVDix+R7
	LCC2iIC/xIe5J8DKmQWcJb4taWYDKRcWsJP4cz8KxBQSCJHYucIdpIJTIFTi6ZFHjBDVOhL7
	W6dBdcpLbF7zlnkCo+AsJAtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	MP66g3HpMatDjAIcjEo8vAE8q4KFWBPLiitzDzFKcDArifDWbwAK8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYLQRyqy+K3KRJcFO6nFf+oGMl9Hpu9fsrfEXWGA/OfvUgertJd3s63KTDI/MWlSw
	f7X0ko8TTlz8XKYp91f8L9+1JtYNl58z/2hvWvTk5XOH3QLF64+KKLDEq8p9e3xhXovM+9k+
	QaWGa85fqTCIfnTy9MZNbiuN6hkl+bQ6nlQlfEtvnsSyVkOJpTgj0VCLuag4EQAU6wjmQQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 18.06.2014 11:52, Charles Keepax wrote:
> In the move to this clock driver the hookups for the SPI clocks were
> dropped, which causes my system Cragganmore (s3c6410 based) to be unable
> to locate any spibus clocks. This patch adds them back in.
> 
> When taking the clock from the epll clock (SCLK) the rates on the SPI
> bus are incorrect, this needs further debugging but the hookup here
> should be correct and the problem should be else where.
> 
> The USBCLK case has been dropped because this requires the USB PHY to be
> enabled.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/clk/samsung/clk-s3c64xx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

Thanks for fixing this. Will apply to my fixes branch.

Best regards,
Tomasz
