Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3ITMHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:07:52 -0400
Received: from ud03.udmedia.de ([194.117.254.43]:36950 "EHLO
	mail.ud03.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3ITMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:07:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2013 08:07:50 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 20 Sep 2013 14:01:08 +0200
From: =?UTF-8?Q?Dieter_N=C3=BCtzel?= <dieter@nuetzel-hh.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm radeon/nouveau/core fixes
Organization: DN
In-Reply-To: <CAPM=9twv-bb3MtnWNTT5+i5HfHQS+cbJG16xsaoL-XV_Qpf9Cw@mail.gmail.com>
References: <CAPM=9twv-bb3MtnWNTT5+i5HfHQS+cbJG16xsaoL-XV_Qpf9Cw@mail.gmail.com>
Message-ID: <cddbd29cf4bcef172196eb4d9f8d0464@mail.ud03.udmedia.de>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.09.2013 04:07, schrieb Dave Airlie:
> Hi Linus,
> 
> mostly radeon fixes, with some nouveau bios parser, ttm fix and a fix
> for AST driver.
> 
> Dave.
> 
> The following changes since commit 
> 01172772c7c973debf5b4881fcb9463891ea97ec:
> 
>   drm/nouveau: fix oops on runtime suspend/resume (2013-09-10 12:38:53 
> +1000)
> 
> are available in the git repository at:
> 
>   git://people.freedesktop.org/~airlied/linux drm-fixes
> 
> for you to fetch changes up to 
> 928c2f0c006bf7f381f58af2b2786d2a858ae311:
> 
>   drm/fb-helper: don't sleep for screen unblank when an oops is in
> progress (2013-09-19 11:54:34 +1000)

[-]

> Christian König (3):
>       drm/radeon: remove stale radeon_fence_retire tracepoint
>       drm/radeon: add command submission tracepoint
>       drm/radeon: avoid UVD corruptions on AGP cards

Alex,

I think your PCIE AGP (radeon.agpmode=-1) UVD fix is missing, here.

Thanks for working UVD and dpm on mostly all asics!

-Dieter
