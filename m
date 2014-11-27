Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaK0Iew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:34:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10270 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaK0Ieu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:34:50 -0500
X-AuditID: cbfee691-f79b86d000004a5a-fe-5476e2287381
Message-id: <5476E215.5020405@samsung.com>
Date: Thu, 27 Nov 2014 14:04:29 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [v3, 1/2] arm64: Create link to include/dt-bindings to enable C
 preprocessor use.
References: <1415727131-4572-2-git-send-email-Liviu.Dudau@arm.com>
In-reply-to: <1415727131-4572-2-git-send-email-Liviu.Dudau@arm.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsWyRsSkRlfjUVmIwcQX/BbHvmxhs/g76Ri7
	xftlPYwW84+cY7Xof7OQ1eLcq5WMFl8Pr2C02PT4GqvF5V1z2CwOLG1nsVh6/SKTxanrn9ks
	Jkxfy2LRuvcIu8XLjydYHPg91sxbw+jx+9ckRo/Lfb1MHiuXf2Hz2LSqk83jzrU9bB6bl9R7
	XDnRxOrxeZNcAGcUl01Kak5mWWqRvl0CV8a/rT3sBT85Ki5d+8DcwLiDvYuRk0NCwESibc9d
	KFtM4sK99WxdjFwcQgJLGSUOPP3ICFM049V5RojEIkaJp59Xs0M4rUwSH6ZeA2vnFdCSuPnz
	HWsXIwcHi4CqRPMGXZAwm4CuxJP3c5lBbFGBCIkra+YwQpQLSvyYfI8FxBYRmMMocWQjE8hM
	ZoEJzBLd926ygSSEBRIkNmx8wApiCwk4SVx+/R4szingLPHqxyqwocwCthIL3q9jgbDlJTav
	ecsMcfVKDonTG3JAbBYBAYlvkw+xgNwmISArsekAVImkxMEVN1gmMIrNQnLSLCRTZyGZuoCR
	eRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYLSf/vds4g7G+wesDzEKcDAq8fBaHCgLEWJN
	LCuuzD3EaAp0xURmKdHkfGBKySuJNzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgXGD/Kxbza+q7wYqz1Tku2BtPPP4Wb6skJrwGFH5YFZL1QjB+e6frs87
	cDX8i8OF7vPTJa5dCDG69zr5a8WfRb1mX2M0nf+9f7XUNOz/Ges8hTPqxZb2Pcoztoi91xLk
	qEyQjvPwmSXNwyLGy/9AYNvBmX+MD0S93tj1vPvSir47xSuMj990qFRiKc5INNRiLipOBAAQ
	UYrs8QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2NR2UhBr/vsloc+7KFzeLvpGPs
	Fu+X9TBazD9yjtWi/81CVotzr1YyWnw9vILRYtPja6wWl3fNYbM4sLSdxWLp9YtMFqeuf2az
	mDB9LYtF694j7BYvP55gceD3WDNvDaPH71+TGD0u9/Uyeaxc/oXNY9OqTjaPO9f2sHlsXlLv
	ceVEE6vH501yAZxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
	Lj4Bum6ZOUAvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz/m3tYS/4
	yVFx6doH5gbGHexdjJwcEgImEjNenWeEsMUkLtxbz9bFyMUhJLCIUeLp59XsEE4rk8SHqdfA
	OngFtCRu/nzH2sXIwcEioCrRvEEXJMwmoCvx5P1cZhBbVCBC4sqaOYwQ5YISPybfYwGxRQTm
	MEoc2cgEMpNZYAKzRPe9m2wgCWGBBIkNGx+wgthCAk4Sl1+/B4tzCjhLvPqxCmwos4CtxIL3
	61ggbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGc
	TJ5J7WBc2WBxiFGAg1GJh9fiQFmIEGtiWXFl7iFGCQ5mJRFeqUVAId6UxMqq1KL8+KLSnNTi
	Q4ymwBCYyCwlmpwPTHR5JfGGxibmpsamliYWJmaWSuK8N27mhggJpCeWpGanphakFsH0MXFw
	SjUwHp00sVd54cNlwbyTmKQ0nfa/EYmLnaud0yhsVfirLaeQy8Q/t1T5drLZgrqZ2y1LxI++
	lm/lqI0od7h944nzjGWbRBbcKje6/eJFuLxpwTGtkD0Od7P9fq98e3eiRar4kilnWc6vOaop
	wK7BfmhdoUb3x11K2Zc3BRZHS/OV56fl3Pt+eu99JZbijERDLeai4kQAHfkTHTwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liviu,

On Tuesday 11 November 2014 11:02 PM, Liviu Dudau wrote:
> DT files used in the compilation phase can be preprocessed by the C
> preprocessor. This requires an include/dt-bindings directory to be
> present in the arch/arm64/boot/dts directory.
>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>

Same change already has been posted as part of adding Exynos7 SoC 
support, as Exynos7 patches have been accepted in Kukjin's tree, I think 
following patch [1] as part of Exynos7 series [2] can also be taken.

1: http://www.spinics.net/lists/devicetree/msg56552.html
2: http://www.spinics.net/lists/devicetree/msg56551.html

Thanks,
Pankaj Dubey

> ---
> arch/arm64/boot/dts/include/dt-bindings | 1 +
>   1 file changed, 1 insertion(+)
>   create mode 120000 arch/arm64/boot/dts/include/dt-bindings
>
> \ No newline at end of file
>
> diff --git a/arch/arm64/boot/dts/include/dt-bindings b/arch/arm64/boot/dts/include/dt-bindings
> new file mode 120000
> index 0000000..08c00e4
> --- /dev/null
> +++ b/arch/arm64/boot/dts/include/dt-bindings
> @@ -0,0 +1 @@
> +../../../../../include/dt-bindings
>
