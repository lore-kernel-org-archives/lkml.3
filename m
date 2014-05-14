Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaENTbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:31:33 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:65245 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaENTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:31:30 -0400
Message-ID: <5373C484.8050506@gmail.com>
Date: Wed, 14 May 2014 21:31:16 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: Mark Rutland <mark.rutland@arm.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, tushar.behera@linaro.org,
        sajjan.linux@gmail.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, Pawel Moll <pawel.moll@arm.com>,
        sachin.kamat@linaro.org, Jaehoon Chung <jh80.chung@samsung.com>,
        thomas.abraham@linaro.org, devicetree@vger.kernel.org, arnd@arndb.de,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, marc.zyngier@arm.com,
        inki.dae@samsung.com, Rob Herring <robh+dt@kernel.org>,
        ben-linux@fluff.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Karol Wrona <k.wrona@samsung.com>, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, kyungmin.park@samsung.com,
        Kumar Gala <galak@codeaurora.org>, olof@lixom.net,
        chanho61.park@samsung.com
Subject: Re: [PATCHv5 3/5] clk: samsung: exynos3250: Add clocks using common
 clock framework
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com> <1399986308-23744-4-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1399986308-23744-4-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 13.05.2014 15:05, Chanwoo Choi wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch add new the clock drvier of Exynos3250 SoC based on Cortex-A7
> using common clock framework. The CMU (Clock Management Unit) of Exynos3250
> control PLLs(Phase Locked Loops) and generate system clocks for CPU, buses,
> and function clocks for individual IPs.

Applied with few minor fixups.

Best regards,
Tomasz
