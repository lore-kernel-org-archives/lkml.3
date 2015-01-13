Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbbAMOrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:47:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:4329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbbAMOq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="636632732"
Date: Tue, 13 Jan 2015 20:15:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: compress_driver.h: include sound/core.h explicitly
Message-ID: <20150113144549.GC3085@intel.com>
References: <1418989110-10011-1-git-send-email-qais.yousef@imgtec.com>
 <54B5048F.2070709@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B5048F.2070709@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:42:07AM +0000, Qais Yousef wrote:
> Ping
> 
> On 12/19/2014 11:38 AM, Qais Yousef wrote:
> >Fixes the following compilation error:
> >
> >    include/sound/compress_driver.h: In function ‘snd_compr_drain_notify’:
> >    include/sound/compress_driver.h:177:2: error: implicit declaration of function ‘snd_BUG_ON’ [-Werror=implicit-function-declaration]
> >      if (snd_BUG_ON(!stream))
> >
> >snd_BUG_ON() is defined in sound/core.h but the file is not included explicitly,
> >so include it.
> >
> >Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> >Cc: Vinod Koul <vinod.koul@intel.com>
> >Cc: Jaroslav Kysela <perex@perex.cz>
> >Cc: Takashi Iwai <tiwai@suse.de>
> >Cc: linux-kernel@vger.kernel.org
> >
Looks okay to me

Acked-by: Vinod Koul <vinod.koul@intel.com>

Thanks
-- 
~Vinod

> >---
> >  include/sound/compress_driver.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
> >index 396e8f73670a..1e2531058b7e 100644
> >--- a/include/sound/compress_driver.h
> >+++ b/include/sound/compress_driver.h
> >@@ -27,6 +27,7 @@
> >  #include <linux/types.h>
> >  #include <linux/sched.h>
> >+#include <sound/core.h>
> >  #include <sound/compress_offload.h>
> >  #include <sound/asound.h>
> >  #include <sound/pcm.h>
> 

-- 
