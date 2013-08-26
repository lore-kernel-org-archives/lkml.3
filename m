Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3HZRNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:13:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42182 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HZRM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:12:58 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-90-521b8c92a992
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        tomasz.figa@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 4/5] clk: samsung: Add clock driver for s5pc110/s5pv210
Date: Mon, 26 Aug 2013 19:12:35 +0200
Message-id: <1433697.46kixytlq2@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1377517114-20222-5-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-5-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA03Ra0hTYRjAcd5z25k5O83bi0LCIEgpnVbwUhF9KY5BN6GkLGzqQSWn40yl
	+aHE28zr8pK6SqcssDW1pkgOcXOaSKI5b100C0Rp6izUSiKybRL47cf7/F+eDw+Ni8eJIDo1
	PZPj02VpEsqLGPm7wByuLguOkVbV+KCmwTESrZYXE6hcN02h0bxVATItzJCouUhPoEnzYwrV
	v+3D0OykCNnbQ9CI8Q2OVioGCPT0nR1Dixo7hTR1bQQaaLViqN1R59KqmkTL/UUE6qhfIVCj
	2kGioXo9QAbzH3A6kDU2GgFbkF9GsbqNKQG7Uq0BbI/2k4Bdft5AsnMzvRTbqb/H9q/1YmxF
	lwGwpesfSXbDtJ99+eTKJdF1r5NJXFpqNsdHnLrllTLaVocpnD53Zt878VzwdU8JoGnIHIWP
	KiNLgNDFADg+30G5LWZaANRvxpYAL5cLMGjMr8TdA4o5Dh+oDcBtP+YYXPs0Q7kjnDET0Pml
	1RP5Mhdhg7NO4DbBHIA9nb88FjGhUG/77mn8mTNwrGWLcFvo6rsGhomdbdUATsxXEDsf9sGt
	6nmPcSYE9llqyR0fgpbCh5QGMNpdmXZXpt2V6QBuAP6cIlGhTEiWR4YrZXJlVnpyeGKG3AQ8
	d14KegWe5SIbYGgg8RYV5wXHiElZtlIltwFI4xI/Ec25nkRJMlUOx2fE81lpnNIGgmlCEiiy
	Fp64LGaSZZncbY5TcPz/KUYLg3LB621pRli3KjbJIvVt5NabVNHoxZp1USDxPt+8rbFqpyPi
	5gKl4s3uwagbDp1Awl/1aRsK5YXiu+Yik4/fiMPiB/eWHlGjqSrpwd/t0deGU+3chwCBPSX5
	R02z/pyo5WzOUl5LVFxVfu1P87cL8Vj8xMbN9fvyhNrPjo7yDgmhTJFFhuG8UvYPsB2/2eMC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 01:38:33 PM Mateusz Krawczuk wrote:
> This patch adds new, Common Clock Framework-based clock driver for Samsung
> S5PV210 SoCs. The driver is just added, without enabling it yet.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  .../bindings/clock/samsung,s5pv210-clock.txt       |  72 ++
>  drivers/clk/samsung/Makefile                       |   3 +-
>  drivers/clk/samsung/clk-s5pv210.c                  | 732 +++++++++++++++++++++
>  include/dt-bindings/clock/samsung,s5pv210-clock.h  | 221 +++++++
>  4 files changed, 1027 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
>  create mode 100644 drivers/clk/samsung/clk-s5pv210.c
>  create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

[...]

> diff --git a/drivers/clk/samsung/clk-s5pv210.c b/drivers/clk/samsung/clk-s5pv210.c
> new file mode 100644
> index 0000000..861d37d
> --- /dev/null
> +++ b/drivers/clk/samsung/clk-s5pv210.c

[...]

> +static unsigned long s5pv210_get_xom(void)

This function can be marked with __init.

> +{
> +	unsigned long xom = 1;
> +	void __iomem *chipid_base;
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "samsung,s5pv210-chipid");
> +	if (np) {
> +		chipid_base = of_iomap(np, 0);

How's about printing an error if !chipid_base?

Also the code can be made a bit shorter:

if (np) {
	void __iomem *chipid_base = of_iomap(np, 0);
...
}

> +		if (chipid_base)
> +			xom = readl(chipid_base + 8);
> +
> +		iounmap(chipid_base);

It seems that at least generic iounmap() accepts NULL argument but it 
will be better not to call it if of_iomap() failed.

> +	}
> +
> +	return xom;
> +}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

