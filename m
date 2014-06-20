Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbaFTR1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:27:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36246 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaFTR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:27:41 -0400
Message-ID: <53A46F09.1050505@ti.com>
Date: Fri, 20 Jun 2014 12:27:37 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Keerthy <j-keerthy@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: Palmas regulator broken (was Re: [PATCH] ARM: tegra: TN7: relax
 some regulators)
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com> <53A308C8.2070004@wwwdotorg.org> <20140619175643.GR5099@sirena.org.uk> <53A3C613.8030207@nvidia.com> <53A3D85E.7030704@nvidia.com> <20140620094119.GT5099@sirena.org.uk> <53A4039B.7000504@nvidia.com> <20140620132310.GA11936@kahuna> <20140620135454.GA10566@kahuna> <CAAVeFuJ=JTNkwDKBvuoyL=ARQs_UJb_MHzL9S8gOc8EU98znPg@mail.gmail.com>
In-Reply-To: <CAAVeFuJ=JTNkwDKBvuoyL=ARQs_UJb_MHzL9S8gOc8EU98znPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:14 AM, Alexandre Courbot wrote:
[...]
> Tried this v2 and it seems to do the trick! My panel switches on as expected.

Thanks. I posted a formal patch
https://patchwork.kernel.org/patch/4391271/ -> might want to add
tested/reviewed/ack on that thread. I hope I got your email ID correct
as well there..

-- 
Regards,
Nishanth Menon
