Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936487Ab3DHObJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:31:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:57715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936250Ab3DHObG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="314728059"
Date: Mon, 8 Apr 2013 16:31:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130408143103.GB21256@zurbaran>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <20130403180423.GA6985@opensource.wolfsonmicro.com>
 <20130408092556.GL24058@zurbaran>
 <20130408093842.GA23639@zurbaran>
 <20130408100409.GB9243@opensource.wolfsonmicro.com>
 <20130408101951.GD9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408101951.GD9243@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Apr 08, 2013 at 11:19:51AM +0100, Mark Brown wrote:
> On Mon, Apr 08, 2013 at 11:04:10AM +0100, Mark Brown wrote:
> 
> > patch series...  I'm just re-tagging and re-pushing but were you testing
> > both serieses together?
> 
> OK, the mirrors seem to have the rebase now.  New pull request:
> 
> The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:
> 
>   Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.10
> 
> for you to fetch changes up to 031eb8d52ecbe417cf778fba2d49bee90a078648:
> 
>   mfd: wm5102: Don't wait for boot when boot sequencer is disabled (2013-04-08 11:12:04 +0100)
> 
> ----------------------------------------------------------------
> mfd: arizona: Updates for v3.10
> 
> This is really a few separate topics which I can split out if required:
> 
>  - WM5102 updates to improve robustness
>  - Improved support for interoperation with edge triggered interrupt
>    controllers
>  - Support for some unusual clocking configurations
>  - A couple small single patch updates and fixes
Thanks, all 19 patches applied now. Everything builds fine on my side.
The culprit for the missing arizona_of_get_core_pdata was "mfd: Add device
tree bindings for Arizona class devices", not the above branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
