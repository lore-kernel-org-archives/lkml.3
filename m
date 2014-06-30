Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaF3Ntm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:49:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53807 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaF3Ntl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:49:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-d5-53b16aef8bc1
Message-id: <53B16AD5.6000805@samsung.com>
Date: Mon, 30 Jun 2014 15:49:09 +0200
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xa7rvszYGG7xfr2rxb8oNdovLu+aw
	Wcw4v4/J4umEi2wOLB53ru1h83g58Tebx+dNcgHMUVw2Kak5mWWpRfp2CVwZm9edZS+Yy1bx
	6kluA+MPli5GTg4JAROJOU+72CBsMYkL99aD2UICSxklVt0s7GLkArI/M0p0XXrKBJLgFdCS
	eLLzLzuIzSKgKnHl4lqwOJuAmsTnhkdgzfxANWuargMt4OAQFYiQeHxBCKJVUOLH5Htge0UE
	/CU+zD0BVs4s4CzxbUkzG0i5sICdxJ/7USCmkECIxM4V7iAVnAKhEk+PPGKEqNaR2N86DapT
	XmLzmrfMExgFZyFZMAtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITwlx2M
	i49ZHWIU4GBU4uFtXLEhWIg1say4MvcQowQHs5II702fjcFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGLV/LOlfLOejun7tPsU7jKtD9tYuvtk0cYmtsUvuAaGS3Y8av6hMVgvnmWE0a+4Swcsv
	mySFuw+9dmhLahZqMow8svnCJtlZB3dpWFuxWqT1BvRmvm8+4PB6quSntqPXOJUnKzhsNXD5
	obExxpO7Ys5DsWtd+RGadwvvs2bwfOlepR7YX+K+VImlOCPRUIu5qDgRACTVmKY/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Applied as a fix for 3.16.

Best regards,
Tomasz

