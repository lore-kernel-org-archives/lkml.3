Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3IXNEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:04:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46277 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3IXNEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:04:20 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c2-52418dd32059
From: Tomasz Figa <t.figa@samsung.com>
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
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, t.stanislaws@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
Subject: Re: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
Date: Tue, 24 Sep 2013 15:04:07 +0200
Message-id: <4983756.tzuZRus2Wn@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xq7qXex2DDO48l7bYOGM9q8WkdQeY
	LJ42/WC3mH/kHKvFuVcrGS16F1xlszjb9IbdYtPja6wWC9uWsFhc3jWHzeJz7xFGixnn9zFZ
	3L7Ma3F6zSlmi7VH7rJbLL1+EWjIhItsFhOmr2Wx6F/Yy2RxeAXQ4HUvp7NYHH7Tzmrx6mAb
	i8W89pesFsdmLGG0WLXrD6PFxq8eDtIea+atYfRoae5h81jw+Qq7x99VL5g9ds66y+6xcvkX
	No9Xq2eyety5tofNY/OSeo+D7/YwefRtWcXo8WhxC6PH501yHhvnhgbwRXHZpKTmZJalFunb
	JXBlrLxqUfCfr+JwL3sD42+uLkYODgkBE4kbX1W6GDmBTDGJC/fWs3UxcnEICSxllDj45BMj
	hNPFJPFo5mdWkCo2ATWJzw2P2EBsEQFTiXd3r4F1MAssZpXY2HUdLCEs4CbRfKYNzGYRUJV4
	0v+aCcTmFdCUWHH0PzuIzS+gLvFu21OwuKiAq8SnhRvB4pwCfhIz3n1jBrGFBHwl9v3fCtUr
	KPFj8j0WEJtZQF5i3/6prBC2lsT6nceZJjAKzkJSNgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukV
	J+YWl+al6yXn525ihCSFrzsYlx6zOsQowMGoxMN7IcEhSIg1say4MvcQowQHs5IIr2atY5AQ
	b0piZVVqUX58UWlOavEhRiYOTqkGxoLe2ZVr9rWH/wmz8D65MVtW8Fl88dQjWfPPvy9W3ety
	IrP+/bHYVVFfste//XP2iH3m8rJtOkZ/v/602nxrv9cDtSdfby6faPD9g7/NSsU3xRu/W8Vu
	ckqQm6O4auMshz33b0XeNeb/fOOwZ9Q8id1Cf+z7Ih8q52yZmyjfK3kx7ne8sNpl519KLMUZ
	iYZazEXFiQBc360D6AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Tuesday 24 of September 2013 14:50:06 Mateusz Krawczuk wrote:
> This patch series is the new s5pv210 clock implementation
> (using common clk framework).
> 
> This implementation is compatible with device tree definition and board
> files.
> 
> This patch series is based on linux-next and has been tested on goni and
> aquila
> boards using board file.
> 
> Since v4:
> Corrected mux flags for finpll.
> 
> Since v3:
> 
> Replace s5pv210_clk_register_finpll, by creating mux finpll
> with xusbxti and xxti as parrents.
> 
> 
> Mateusz Krawczuk (3):
>   clk: samsung: Add clock driver for s5pc110/s5pv210
>   Cpufreq: s5pv210 cpufreq fixes for CCF
>   ARM: s5pv210: Migrate clock handling to Common Clock Framework
> 
>  .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
>  arch/arm/mach-s5pv210/Kconfig                      |   9 +
>  arch/arm/mach-s5pv210/Makefile                     |   4 +-
>  arch/arm/mach-s5pv210/common.c                     |  17 +
>  arch/arm/mach-s5pv210/common.h                     |  10 +
>  arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
>  arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
>  arch/arm/plat-samsung/Kconfig                      |   2 +-
>  drivers/clk/samsung/Makefile                       |   3 +
>  drivers/clk/samsung/clk-s5pv210.c                  | 673 +++++++++++++++++++++
>  drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
>  include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
>  12 files changed, 1019 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
>  create mode 100644 drivers/clk/samsung/clk-s5pv210.c
>  create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

For this series:

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

