Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaLHLcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:32:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40244 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbaLHLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:32:08 -0500
X-AuditID: cbfee68e-f79b46d000002b74-3f-54858c3671a6
Message-id: <54858C3C.9020701@samsung.com>
Date: Mon, 08 Dec 2014 17:02:12 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/19] clk: samsung: exynos5433: Add clocks for CMU_PERIS
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWyRsSkTtespzXE4McNDovHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6Mn2tYC/6wVey9
	/5C9gfElaxcjJ4eEgIlE99sPLBC2mMSFe+vZQGwhgaWMElNaa2Fqvh7cyAwRn84oseCoQxcj
	F5DdyiTx8NsnsGZeAS2J+c2fwWwWAVWJI6c+gw1iE9CVePJ+LlizqECExJU1cxgh6gUlfky+
	B1YvIpAt8fTNYTaQocwCO5klzndPAUpwcAgLhEmsm+sPsbhe4sfWDrCjOQVcJeataWMHsZkF
	bCUWvF/HAmHLS2xe85YZZI6EwAEOif2P97BCHCQg8W3yIbCZEgKyEpsOMEM8JilxcMUNlgmM
	YrOQnDQLydhZSMYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRGYDk7/e9a3g/HmAetD
	jAIcjEo8vAsetIQIsSaWFVfmHmI0BbpiIrOUaHI+MOnklcQbGpsZWZiamBobmVuaKYnzJkj9
	DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKJoRr/Y3rP6ykcymM3f5lsgucOG/veCrkFHo
	lW7Wpc4iHyL/aSR12CVY3p9e9nDjzbWL/V8YfO2paP7ansOr9JqRZ0XO00AGp3N7bmb/1Fwt
	dGnNiqMlnlNro6wiJj693+Cxzcme+yJLnwk7i3FwQeunxY8P2dV99Ql4vc6v/atm63E3jQgm
	JZbijERDLeai4kQAjc5VawIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQV3TntYQgydzbCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnN4vCbdlaLGZNfslms2vWH0eLlxxMsDqIea+atYfT4
	/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih
	6xsSBNdjZIAGEtYwZvxcw1rwh61i7/2H7A2ML1m7GDk5JARMJL4e3MgMYYtJXLi3ng3EFhKY
	ziix4KhDFyMXkN3KJPHw2ycWkASvgJbE/ObPYDaLgKrEkVOfwRrYBHQlnryfCzZIVCBC4sqa
	OYwQ9YISPybfA6sXEciWePrmMBvIUGaBncwS57unACU4OIQFwiTWzfWHWFwv8WNrB9hxnAKu
	EvPWtLGD2MwCthIL3q9jgbDlJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcLp5Jr2DcVWDxSFGAQ5GJR7ehQ9aQoRYE8uKK3MPMUpwMCuJ8CbGtYYI
	8aYkVlalFuXHF5XmpBYfYjQFhsBEZinR5HxgKswriTc0NjE3NTa1NLEwMbNUEue9cTM3REgg
	PbEkNTs1tSC1CKaPiYNTqoExSp+18n+7Wdqst0fXnJGK/eLkH/Q2NSFl8/c2rc1vS9bwbv6f
	NdevM7kv9cXtOTdv7fYJXT3lqtz0qA2xmx4+b93mka3au7bhUqnhpdSEzu2Hc/s9eO1mLN/l
	Ibbx8s40jlDhwy9XBh/aFPt4+vrb8VLhTjdelbadidv5a1o0s22G4ON7lx7rKrEUZyQaajEX
	FScCAKU2/v9NAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds missing gate clocks of CMU_PERIS domain
> which includes TMU/TZPC/SECKEY/CHIPID/TOPRTC/EFUSE IPs.
> The special clocks of CMU_PERIS use fin_pll source clock directly.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos5433.c   | 146 ++++++++++++++++++++++++++++++++-
>   include/dt-bindings/clock/exynos5433.h |  33 +++++++-
>   2 files changed, 176 insertions(+), 3 deletions(-)
>

Verified all registers and clock relationship against UM I have, and 
changes are OK.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks,
Pankaj Dubey

