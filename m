Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaJPKsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:48:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56778 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaJPKsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:48:19 -0400
Date: Thu, 16 Oct 2014 11:48:59 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
Message-ID: <20141016104859.GA29308@red-moon>
References: <5230569.XLlNbB5NvF@amdc1032>
 <018e01cfd885$770dd940$65298bc0$@kernel.org>
 <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
 <5423D19B.1040203@samsung.com>
MIME-Version: 1.0
In-Reply-To: <5423D19B.1040203@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Oct 2014 10:48:16.0540 (UTC) FILETIME=[B10FBDC0:01CFE92E]
X-MC-Unique: 114101611481704001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:26:03AM +0100, Kukjin Kim wrote:
> On 09/25/14 17:17, Lorenzo Pieralisi wrote:
> > [CC'ed Daniel to make him aware this patch goes through your tree]
> >
> Thanks and just note the branch  which is including this change actually 
> v4 is just rebased not v3 will be sent out to arm-soc last tonight or 
> tomorrow.

What's the plan for patch ? I do not see it upstream and would like
to rebase the Exynos CPUidle changes on top of it.

Thanks,
Lorenzo

