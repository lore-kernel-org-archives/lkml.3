Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3GUPir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:38:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42833 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3GUPiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:38:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,713,1367971200"; 
   d="scan'208";a="36453850"
Date: Sun, 21 Jul 2013 16:38:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Julien Grall <julien.grall@linaro.org>, <ian.campbell@citrix.com>,
        <patches@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2] xen/arm: disable cpuidle and cpufreq when linux is
 running as dom0
In-Reply-To: <alpine.DEB.2.02.1307211508520.4893@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1307211638260.4893@kaball.uk.xensource.com>
References: <1374233220-13770-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307211508520.4893@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Stefano Stabellini wrote:
> On Fri, 19 Jul 2013, Julien Grall wrote:
> > When linux is running as dom0, Xen doesn't show the physical cpu but a
> > virtual CPU.
> > On some ARM SOC (for instance the exynos 5250), linux registers callbacks
> > for cpuidle and cpufreq. When these callbacks are called, they will modify
> > directly the physical cpu not the virtual one. It can impact the whole board
> > instead of only dom0.
> > 
> > Signed-off-by: Julien Grall <julien.grall@linaro.org>
> > 
> 
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I added the patch to my queue
