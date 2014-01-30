Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaA3SgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:36:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaA3SgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:36:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
Date: Thu, 30 Jan 2014 19:35:16 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, alexandre.torgue@st.com,
        maxime.coquelin@st.com
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-2-git-send-email-patrice.chotard@st.com>
In-Reply-To: <1391093744-19905-2-git-send-email-patrice.chotard@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301935.16463.arnd@arndb.de>
X-Provags-ID: V02:K0:Tuxtf1w/xeMmdGdhBYQMpSI77Hhm1e9EVswS3wslS2b
 ABj/aTtkX006cbbv1eJlmtIA9Svs8dExHG5m6O4PQDXuAKMX6l
 m18d4MAdKJNUa9i2ik0rtQbSaPZsjVAHbH3Hy+2K+XPsqBLiUy
 YBotvDuhkJuZ/bwuANN/q6bedu5EtEbWw0vC6Q7WfLxX8aas5j
 iXWJTDV2SMO2AFbZA4jl+unMIxmnfq1PubVpdvxxOk8NztMvnu
 4hzsTUQ7gqtrqeGEVinCNy+Pxtf38q5iIlAvIuXlrnSs35AgwJ
 EfPUmiOwBVF/2ru5vsAtloKueFKwUSfTuH5gNs1lZFt4iStVDO
 t84i5Uc+Mb5UwCeqd7O3Z0/zGcAE0SvmODTWgPWiU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Patrice CHOTARD wrote:
> From: Alexandre TORGUE <alexandre.torgue@st.com>
> 
> This patch adds support to STiD127 SoC.
> The main adaptation is the L2 cache way size compare to STiH41x SoCs.
> 
> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> ---
>  arch/arm/mach-sti/board-dt.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Wouldn't it be better to read this value from the l2 cache
controller node? I'd assume there might be more SoCs that
will need a similar change, so it's better to come up with
a solution that doesn't involve changing the kernel every
time.

	Arnd
