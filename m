Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3DWS5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:57:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3DWS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:57:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 07/21] ARM: tegra: unify tegra_idle_device definitions
Date: Tue, 23 Apr 2013 20:57:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-8-git-send-email-arnd@arndb.de> <5176BD29.1000405@linaro.org>
In-Reply-To: <5176BD29.1000405@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232057.37055.arnd@arndb.de>
X-Provags-ID: V02:K0:+M9luFmksYDmS2jxfvgeDUQ0dBueKV10Ixwih9d//Q9
 HmaRtqqJgJTWgbVB/l8yu2NXawr0kzDlBKmEOxhQ7uHS93P2FQ
 unVloi6wvLeEkHLaDdmuxLzTOUt3NleLPRLrn9AhX6HiL/jWis
 4OnR59NJ+HtRiWF2yL3+EAkjdpXJgR0GwdsHlAjvigPPn6Hjx7
 w8dkyKi2/07UGl6GkTgumclugnvnuk/IPKZOX82cHsd4iCAIwG
 n1FLFMagqy/3bx8uqCAr80LjEDvfb/hfmwJuDelUvBii41EsBn
 YDISadnIB/uzrkWBCh75ElbOk7z6YwTC2hcGAeRlf3/0ULmGEN
 aH8HF0UaTwuOsEH3sgM4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Daniel Lezcano wrote:
> the patch sounds good but I think the side effect of the consolidation
> patchset [1] fixed that.
> 
> You can find these fixes in Rafael's tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=4c637b2175a0dc65d533494225525c6c82d73293
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=e158f9da6974cc11bfab2246a9b10021af0e0d8a
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=c5106c9dea9a6022ab84c6cb1d4a0b19fc5af0e2
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=f040c26ffaa5e56f2bca427c719c9601a02e70e5
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg239811.html
> 

Ah. Is that not in linux-next? I created the patch today based on the latest
linux-next from today (Tuesday).

	Arnd
