Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3IXN6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:58:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3IXN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:58:11 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-62-52419a71ba16
Message-id: <52419A6E.9020203@samsung.com>
Date: Tue, 24 Sep 2013 15:58:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: rjw@sisk.pl, kgene.kim@samsung.com, viresh.kumar@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v5 1/3] clk: samsung: Add clock driver for s5pc110/s5pv210
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1380027009-2239-2-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1380027009-2239-2-git-send-email-m.krawczuk@partner.samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xq7qFsxyDDOb0SVpsnLGe1WLSugNM
	Fk+bfrBbzD9yjtXi3KuVjBa9C66yWZxtesNusenxNVaLhW1LWCwu75rDZvG59wijxYzz+5gs
	bl/mtTi95hSzxdojd9ktll6/CDRkwkU2iwnT17JY9C/sZbI4vAJo8LqX01ksXh1sY7GY1/6S
	1eLYjCWMFqt2/WG02PjVw0HKY828NYweLc09bB4LPl9h9/i76gWzx85Zd9k9Vi7/wubxavVM
	Vo871/aweWxeUu9x8N0eJo++LasYPR4tbmH0+LxJzmPj3NAAvigum5TUnMyy1CJ9uwSujPPT
	37EWrGSrWPl1J1MD43TWLkZODgkBE4nGPafYIWwxiQv31rN1MXJxCAksZZTY/fUJO4TziVHi
	Qe8xZpAqXgEtiXMrXrKB2CwCqhLvGhaD2WwChhK9R/sYQWxRgQCJxUvOsUPUC0r8mHyPBcQW
	ETCVeHf3GtgGZoFuVokP61vAhgoL+Enc3nWbBWLbREaJ6692gU3lBEosfrIbbCqzgI7E/tZp
	bBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECIn9
	rzsYlx6zOsQowMGoxMN7IcEhSIg1say4MvcQowQHs5IIr2atY5AQb0piZVVqUX58UWlOavEh
	RiYOTqkGxnV73LRv8b93Du+1uMY3I0Hr+yIFfRe2yo+ebYmu3HXNHif2bzoRs62u0lbkR9zK
	2uue90s+x8YGKkUbBPhvncT049PMmpYyZo5Pt8O2XT89UaOXaUWglK//laIeAQfes5zyMxpl
	Si5p9e7b8y7Fd8OZZPf32v2y4WXncvss50qn767f8IBZiaU4I9FQi7moOBEA0fkQatsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/09/13 14:50, Mateusz Krawczuk wrote:
> +++ b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> @@ -0,0 +1,75 @@
> +* Samsung S5PC110/S5PV210 Clock Controller
> +
> +The S5PV210 clock controller generates and supplies clock to various controllers
> +within the SoC. The clock binding described here is applicable to all SoCs in
> +the S5PC110/S5PV210 family.
> +
> +Required Properties:
> +
> +- compatible: should be "samsung,s5pv210-clock".

I have nothing against this compatible value, but wouldn't it be more
accurate to use, e.g. "samsung,s5pv210-cmu" - for Clock Management Unit,
as this IP block is also referred to in the documentation ?

May just be me, but "samsung,s5pv210-clock" sounds like just one
specific clock type.

--
Thanks,
Sylwester
