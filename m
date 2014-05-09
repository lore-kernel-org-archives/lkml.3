Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaEIHts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:49:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:60195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaEIHtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:49:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1016,1389772800"; 
   d="scan'208";a="508881627"
Date: Fri, 9 May 2014 10:49:42 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [alsa-devel] [PATCH] sound: soc: intel: remove unneeded
 dependency from Makefile
Message-ID: <20140509074942.GA19551@mylly>
References: <1399526771-28422-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399526771-28422-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 10:56:11AM +0530, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch removes drops the entries form Makefile, fixing
> following issues when make clean was run,
> 
> scripts/Makefile.clean:17: sound/soc/intel/board/Makefile: No such file or directory
> scripts/Makefile.clean:17: sound/soc/intel/sst/Makefile: No such file or directory
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Found this issue on linux-next not sure if this is fixed in
>  sound subsystem tree.
>  
This hit me too and was introduced in 1eee978f4258
("ASoC: Intel: split the pcm and compress to different files").

Vinod, do you have something coming soon to these Makefiles or would it be
better take this now?

Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
