Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaJKQ2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:28:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:58870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaJKQ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:28:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603888920"
Date: Sat, 11 Oct 2014 21:24:11 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: dmaengine@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ASoC: txx9: use dmaengine_terminate_all() API
Message-ID: <20141011155411.GA1638@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-11-git-send-email-vinod.koul@intel.com>
 <5439591B.4020701@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5439591B.4020701@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 06:21:47PM +0200, Lars-Peter Clausen wrote:
> On 10/11/2014 05:40 PM, Vinod Koul wrote:
> >The drivers should use dmaengine_terminate_all() API instead of
> >accessing the device_control which will be deprecated soon
> 
> I already send a similar patch a while ago. It is on it's way into 3.18.
I will drop this one then

I did grep the linux-next when I started on this and found no reductions
from what I had in dmaengine-next

-- 
~Vinod

