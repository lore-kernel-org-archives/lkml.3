Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbaGRLPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:15:48 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63351 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbaGRLPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:15:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
Date: Fri, 18 Jul 2014 13:14:55 +0200
Message-ID: <6917971.QKItNU3coA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C8F050.6060104@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <6485839.CnzmD0SeQj@wuerfel> <53C8F050.6060104@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WTmn0vZfoLqG5cCDSFNnyw4DdLS34/WPN4ZAo8wGh0u
 De3KuqB1Gzv54H3l8VwvO0PPCZc2/pDoSP4KAQV3QUutRH7xLH
 VT1nopabKFvbBrdg3qMCieCqZbjbJoWZxhxwAflbfEAw5Pq+fv
 PlIKtKuaAES8KqyebGODtufHdqGst1OJUqOISi9mwnWknupudo
 WlKjOGTUABzrsyfWnhGgSNY3aHiUVk3rBQE0JG5wPE+J69PFZ4
 8IBwVvn5si0FDRPj6K/KruIZ+7y4fryagnabBsqxTB/0UgR9OO
 cGPUhHLgOn8zjUt9Sau3G9kXetoNSfzZxx5PJ02OG3F7xNuDy6
 OlgkpNsVvwksH6q1JObY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 19:00:48 Chanwoo Choi wrote:
> On 07/18/2014 06:47 PM, Arnd Bergmann wrote:
> > 
> > Further, why is it called "sclk_adc" rather than just "sclk"?
> 
> The sclk means 'special clock' in Exynos TRM. Exynos SoC has varisou sclk clocks.
> 'sclk_adc' is only used for ADC IP.

But that sounds like sclk_adc is the name of the global name
of the clock signal coming out of the clock controller.

I still think it would be best to name it 'sclk' as the input
for the adc. It shouldn't rely on a particular name of the
clock controller.

	Arnd
