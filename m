Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaG1Llx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:41:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:56803 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaG1Llv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:41:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,748,1400050800"; 
   d="scan'208";a="550096716"
Date: Mon, 28 Jul 2014 17:04:21 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: nsekhar@ti.com, joelf@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        dmaengine@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 0/2] dma: edma: Allow to disable eDMA IRQ during cyclic
 transfer
Message-ID: <20140728113421.GA8181@intel.com>
References: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:29:19PM +0300, Peter Ujfalusi wrote:
> Hi,
> 
> After this series clients can ask to not receive notifications after each period.
> In this case we can disable the completion interrupt since the position reporting
> does not rely on it for cyclic mode.
> Patchset for ASoC part has been sent which allows users space to take adventage
> of SNDRV_PCM_INFO_NO_PERIOD_WAKEUP:
> [1] http://mailman.alsa-project.org/pipermail/alsa-devel/2014-July/078993.html

Applied, thanks

Please use right subsystem name for patches, i have fixed that while
applying

-- 
~Vinod

