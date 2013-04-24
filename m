Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3DXC4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:56:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13605 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3DXC4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:56:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Apr 2013 19:56:36 -0700
Subject: Re: [PATCH 07/21] ARM: tegra: unify tegra_idle_device definitions
From: Joseph Lo <josephl@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
In-Reply-To: <5177055D.1060307@linaro.org>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	 <1366734653-488286-8-git-send-email-arnd@arndb.de>
	 <5176BD29.1000405@linaro.org> <201304232057.37055.arnd@arndb.de>
	 <5177055D.1060307@linaro.org>
Date: Wed, 24 Apr 2013 10:56:35 +0800
Message-ID: <1366772195.18275.3.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 06:04 +0800, Daniel Lezcano wrote:
> On 04/23/2013 08:57 PM, Arnd Bergmann wrote:
> > On Tuesday 23 April 2013, Daniel Lezcano wrote:
> >> the patch sounds good but I think the side effect of the consolidation
> >> patchset [1] fixed that.
> >>
> >> You can find these fixes in Rafael's tree:
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=4c637b2175a0dc65d533494225525c6c82d73293
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=e158f9da6974cc11bfab2246a9b10021af0e0d8a
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=c5106c9dea9a6022ab84c6cb1d4a0b19fc5af0e2
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=f040c26ffaa5e56f2bca427c719c9601a02e70e5
> >>
> >> [1] http://www.spinics.net/lists/arm-kernel/msg239811.html
> >>
> > 
> > Ah. Is that not in linux-next? I created the patch today based on the latest
> > linux-next from today (Tuesday).
> 
> Ah, ok. Actually the patches were taken by Rafael right today. So it is
> possible the changes were not reflected in linux-next yet.
> 
Hi Arnd and Daniel,

Thanks for taking care this.:)

Joseph

