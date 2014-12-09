Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaLIHsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:48:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaLIHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:48:17 -0500
X-AuditID: cbfee68d-f79296d000004278-8e-5486a93e579c
Message-id: <5486A948.7010906@samsung.com>
Date: Tue, 09 Dec 2014 13:18:24 +0530
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
Subject: Re: [PATCH 12/19] clk: samsung: exynos5433: Add clocks for CMU_GSCL
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-13-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-13-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkStduZVuIwYSnQhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmcfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ6w89Yy7YKVZx
	e+sttgbGx0JdjJwcEgImEs8uNbBC2GISF+6tZ+ti5OIQEljKKLFtxT8mmKLJzz+wQyQWMUps
	mHMZqqqVSWLV76ssIFW8AloS67ZMYgexWQRUJbZ3bgUbyyagK/Hk/VxmEFtUIELiypo5jBD1
	ghI/Jt8D6xURyJZ4+uYw2FBmgZ3MEue7p4AlhAVCJWat6oJa3cAo8WnSK7ANnAJuEoeX7wGb
	yixgK7Hg/ToWCFteYvOat8wgDRICezgk/nZtZYE4SUDi2+RDQDYHUEJWYtMBZojfJCUOrrjB
	MoFRbBaSo2YhGTsLydgFjMyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQITw+l/z3p3MN4+
	YH2IUYCDUYmHV8OyLUSINbGsuDL3EKMp0BUTmaVEk/OB6SevJN7Q2MzIwtTE1NjI3NJMSZxX
	UepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGx+Ivld92L5AI6NMWD2CUV+w6yh+6ov+4
	j49jcd2Frt5NKwuvTprpcka+aaJk5d8Zb//0lB1lUeNWXcbV9mP3txkC5eWfk04ktxi/SM7a
	m2y9vMC86nOc/3vuaIs/uec3TJu3+/JUW+0pv1i8deMnFnnYcbxru3qj+V1e7YMv83niTV0b
	16grsRRnJBpqMRcVJwIAQEhGiwcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV27lW0hBrOvcVg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzFh/6BlzwU6xittbb7E1MD4W6mLk5JAQMJGY/PwDO4QtJnHh3nq2LkYu
	DiGBRYwSG+ZchnJamSRW/b7KAlLFK6AlsW7LJLAOFgFVie2dW1lBbDYBXYkn7+cyg9iiAhES
	V9bMYYSoF5T4MfkeWK+IQLbE0zeHwYYyC+xkljjfPQUsISwQKjFrVRc7xLYGRolPk16BbeAU
	cJM4vHwP2FRmAVuJBe/XsUDY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzjtPJPewbiqweIQowAHoxIPr4ZlW4gQa2JZcWXuIUYJDmYlEV6lpUAh
	3pTEyqrUovz4otKc1OJDjKbAMJjILCWanA9MiXkl8YbGJuamxqaWJhYmZpZK4rxK9kBNAumJ
	JanZqakFqUUwfUwcnFINjPXJmdZrNW8KpGRfEFLw5AuouXEuLVquJj0i3jHLn/FclLjq5SVX
	lyxe7cO5tDo1aslEL4PvhcJ8m9e84K40nxO4SN9hHtsSc/GvC54dt1guw/5MtdSxw8323po7
	OzfXFyZc0rSMlmQ22bB8yiRd3TfuG6O2POs5fj7/omVmtP+eD5dLq37/V2Ipzkg01GIuKk4E
	AG43nNZRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the divider/gate of CMU_GSCL domain which contains gscaler
> clocks.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
>   drivers/clk/samsung/clk-exynos5433.c               | 144 +++++++++++++++++++++
>   include/dt-bindings/clock/exynos5433.h             |  37 +++++-
>   3 files changed, 188 insertions(+), 1 deletion(-)
>

[snip]

>   }
>   CLK_OF_DECLARE(exynos5433_cmu_g3d, "samsung,exynos5433-cmu-g3d",
>   		exynos5433_cmu_g3d_init);
> +
> +/*
> + * Register offset definitions for CMU_GSCL
> + */
> +#define MUX_SEL_GSCL				0x0200
> +#define MUX_ENABLE_GSCL				0x0300
> +#define	MUX_STAT_GSCL				0x0400
> +#define	ENABLE_ACLK_GSCL			0x0800
> +#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0	0x0804
> +#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1	0x0808
> +#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2	0x080c
> +#define	ENABLE_PCLK_GSCL			0x0900
> +#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0	0x0904
> +#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL1	0x0908
> +#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL2	0x090c
> +#define	ENABLE_IP_GSCL0				0x0b00
> +#define	ENABLE_IP_GSCL1				0x0b04
> +#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL0	0x0b08
> +#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL1	0x0b0c
> +#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL2	0x0b10
> +

nit: tabspace after #define should be changed to one whitespace.

> +static unsigned long gscl_clk_regs[] __initdata = {
> +	MUX_SEL_GSCL,
> +	MUX_ENABLE_GSCL,
> +	MUX_STAT_GSCL,
> +	ENABLE_ACLK_GSCL,
> +	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0,
> +	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1,
> +	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2,
> +	ENABLE_PCLK_GSCL,
> +	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0,
> +	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL1,
> +	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL2,
> +	ENABLE_IP_GSCL0,
> +	ENABLE_IP_GSCL1,
> +	ENABLE_IP_GSCL_SECURE_SMMU_GSCL0,
> +	ENABLE_IP_GSCL_SECURE_SMMU_GSCL1,
> +	ENABLE_IP_GSCL_SECURE_SMMU_GSCL2,
> +};
> +
> +/* list of all parent clock list */
> +PNAME(aclk_gscl_111_user_p)	= { "fin_pll", "aclk_gscl_111", };
> +PNAME(aclk_gscl_333_user_p)	= { "fin_pll", "aclk_gscl_333", };
> +
> +static struct samsung_mux_clock gscl_mux_clks[] __initdata = {
> +	/* MUX_SEL_GSCL */
> +	MUX(CLK_MOUT_ACLK_GSCL_111_USER, "mout_aclk_gscl_111_user",
> +			aclk_gscl_111_user_p, MUX_SEL_GSCL, 4, 1),
> +	MUX(CLK_MOUT_ACLK_GSCL_333_USER, "mout_aclk_gscl_333_user",
> +			aclk_gscl_333_user_p, MUX_SEL_GSCL, 4, 1),

aclk_gscl_333_user mux clock has a shift of '0'.

> +};
> +

Thanks,
Pankaj Dubey
