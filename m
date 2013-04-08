Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab3DHJ01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:26:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:30145 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484Ab3DHJ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:26:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="314579500"
Date: Mon, 8 Apr 2013 11:25:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130408092556.GL24058@zurbaran>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <20130403180423.GA6985@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403180423.GA6985@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Apr 03, 2013 at 07:04:23PM +0100, Mark Brown wrote:
> On Mon, Apr 01, 2013 at 06:27:48PM +0100, Mark Brown wrote:
> 
> > mfd: arizona: Updates for v3.10
> > 
> > This is really a few separate topics which I can split out if required:
> > 
> >  - WM5102 updates to improve robustness
> >  - Improved support for interoperation with edge triggered interrupt
> >    controllers
> >  - Support for some unusual clocking configurations
> >  - A couple small single patch updates and fixes
> > 
> 
> A few more updates for this which I'll post just now, I've updated the
> tag and branch:
> 
> The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:
> 
>   Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.10
Thanks, I pulled this one into mfd-next now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
