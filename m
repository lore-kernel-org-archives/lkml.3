Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab3HOQXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:23:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab3HOQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:23:39 -0400
Message-ID: <520D0084.8090604@infradead.org>
Date: Thu, 15 Aug 2013 09:23:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Witten <mfwitten@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: [PULL] Miscellaneous trivialities
References: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com>
In-Reply-To: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/13 02:44, Michael Witten wrote:
> I've been sitting on some trivial patches for a while, and I'd just
> like to get them out of the way.
> 
> Here is the series:
> 
>   [1] Docs: Kconfig: For readability, offset modifiers with commas
>   [2] Docs: Kconfig: Use consistent whitespace indentation
>   [3] Docs: Kconfig: Clean up the radiotap documentation
>   [4] Docs: Kconfig: `devlopers' -> `developers'
>   [5] Docs: Replace `hotplug' with `udev'
>   [6] DRM: comment: halve -> half
>   [7] DRM: comment: gdm_proc_lists -> drm_proc_lists
>   [8] DRM: cleanup: Remove unused `gamma_size'
> 
>   Documentation/networking/README.ipw2200 |   5 +-
>   drivers/gpu/drm/drm_fb_helper.c         |   3 -
>   drivers/gpu/drm/drm_irq.c               |   4 +-
>   drivers/gpu/drm/drm_proc.c              |   2 +-
>   drivers/net/wireless/ipw2x00/Kconfig    | 102 ++++++++++++++++----------------
>   fs/btrfs/Kconfig                        |   3 +-
>   init/Kconfig                            |   4 +-
>   7 files changed, 60 insertions(+), 63 deletions(-)
> 
> Those commits merge cleanly with:
> 
>   28fbc8b6a29c849a3f03a6b05010d4b584055665
>   Merge branch 'sched-urgent-for-linus' of
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>     (2013-08-13 16:58:17 -0700)
> 
> and they can be pulled from here:
> 
>   https://github.com/mfwitten/linux.git trivial/misc/0
> 
> While it is much easier to review the individual commits, a combined
> diff is appended to the end of this email in case that is convenient.

Looks good to me.
Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>



-- 
~Randy
