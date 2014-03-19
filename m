Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaCSQym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:54:42 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65528 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <532997D7.6090608@samsung.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
	<5322FD14.5090602@samsung.com>
	<20140318185605.0380c8dfe6559c06183092e5@samsung.com>
	<532861BE.7020601@samsung.com>
	<20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
	<532997D7.6090608@samsung.com>
Date: Wed, 19 Mar 2014 09:54:39 -0700
X-Google-Sender-Auth: sVDdTJdjLu3Zd1Xj6c5QNAPm1Mc
Message-ID: <CANEJEGtK-XfTef3ko+Yq2RNFXohhuQjgamr-DRBmxR-SNzgkJg@mail.gmail.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API functions
From: Grant Grundler <grundler@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:12 AM, Tomasz Figa <t.figa@samsung.com> wrote:
...
>> Device driver is not only for the scholarship but also for the real use.
>
> Huh? I'm not sure what kind of comment is this.

I'm guessing Cho meant: "This isn't an academic exercise - I have a
real use case that requires reference counting."

Cho needs to be more specific about his "Some driver needs enabling
sysmmu" example. Then others would understand why/when the reference
counting is needed. Ie walk through a real driver that exists today
that depends on reference counting.

cheers,
grant
