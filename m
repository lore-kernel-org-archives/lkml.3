Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaCRLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:16:26 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54985 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCRLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140318201424.e8bde8514726c3639243e9ad@samsung.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
	<CAK9yfHx_FUaUcA_tpsJ73i0iJmczOp7K8gC6sMGHQ6c50i46=A@mail.gmail.com>
	<20140318201424.e8bde8514726c3639243e9ad@samsung.com>
Date: Tue, 18 Mar 2014 16:46:24 +0530
Message-ID: <CAK9yfHy+uiRPZjEDzZRpNKVY1CnWehVGdJmu3ztOTXAuHBx_Yg@mail.gmail.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 16:44, Cho KyongHo <pullip.cho@samsung.com> wrote:
> On Fri, 14 Mar 2014 20:57:42 +0530, Sachin Kamat wrote:
>> Hi KyongHo,
>>
>> On 14 March 2014 10:39, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> >
>> > -static struct platform_driver exynos_sysmmu_driver = {
>> > -       .probe          = exynos_sysmmu_probe,
>> > -       .driver         = {
>> > +#ifdef CONFIG_OF
>>
>> This is not needed as Exynos is DT only platform.
>>
> Yes, but I hesitate to remove that.

What is the reason for your hesitation? :)


-- 
With warm regards,
Sachin
