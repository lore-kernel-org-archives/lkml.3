Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaCGH2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:28:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17166 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCGH2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:28:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-8a-5319750c224b
Message-id: <1394177291.20224.1.camel@AMDC1943>
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Fri, 07 Mar 2014 08:28:11 +0100
In-reply-to: <20140307015139.GS13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
 <20140306093826.GO13126@sirena.org.uk> <1394099334.25853.1.camel@AMDC1943>
 <20140307015139.GS13126@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xy7o8pZLBBk3HjS02zljPajH14RM2
	i7NNb9gt7n89ymjx7UoHk8XlXXPYLGac38dksfbIXXaLk396GS1Od7NaXFzxhcli/YzXLBZz
	pr9jcuD12DnrLrvHplWdbB53ru1h85h3MtCjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MnoW
	RBRsZ6l4f/YmewPjWeYuRk4OCQETiQV73jNC2GISF+6tZ+ti5OIQEljKKHH5/zl2COczo8SU
	/4/YQap4BfQlPu27ANYtLBAgsX7NJzCbTcBYYvPyJWwgtoiAssTV73tZQJqZBV4xSzzYPQks
	wSKgKjF7ag8riM0J1HDg7GNmiA0/GSXebf0LtoFZQF1i0rxFUPcpSexu74SKy0tsXvOWGeIK
	QYkfk++xTGAUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImVLzsY
	Fx+zOsQowMGoxMNrsEAiWIg1say4MvcQowQHs5IIb32yZLAQb0piZVVqUX58UWlOavEhRiYO
	TqkGRgFrwacc97TNzmk/Y7j64NqKe8a+Pb0/S/lE/lUd+HG4s8nEv2uywzydGaKXS05/vSwR
	HbUoRmCWauyWvJII9x4B60u6QrzOhQ+DHC9c05pq94nDulpm6v6W921MLN/lRdLlmBbd0lvE
	nF1ndJlZ3LHf/PIhxaqt0dGzP2gxzvUMZ3ZhVfRWYinOSDTUYi4qTgQAlKegbnMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 09:51 +0800, Mark Brown wrote:
> On Thu, Mar 06, 2014 at 10:48:54AM +0100, Krzysztof Kozlowski wrote:
> 
> > Anyway can you look at other two patches and apply them if they are OK?
> > They don't depend on this.
> 
> There appears to be some external dependency for the definition of
> macros like S2MPS14X?
The patchset depends on S2MPS14 support for MFD driver. This was applied
by Lee here:
https://git.linaro.org/people/lee.jones/mfd.git/shortlog/refs/heads/for-mfd-next
and merged into linux-next.

Best regards,
Krzysztof

