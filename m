Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3EXWHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:07:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:1149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3EXWHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:07:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,737,1363158000"; 
   d="scan'208";a="246331658"
Date: Sat, 25 May 2013 00:07:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/7] mfd: arizona: Updates for v3.11
Message-ID: <20130524220714.GA15399@zurbaran>
References: <20130521181230.GF1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521181230.GF1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, May 21, 2013 at 01:12:30PM -0500, Mark Brown wrote:
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-v3.10-rc2
> 
> for you to fetch changes up to f773fc6dca4619bdf8da767eaba101a83b766059:
> 
>   mfd: arizona: Change fast_start pdata name to better reflect functionality (2013-05-21 12:41:54 -0500)
> 
> ----------------------------------------------------------------
> mfd: arizona: Updates for v3.10
> 
> A bunch of enhancements and fixes for the arizona devices, adding a few
> new features (the main one being device tree) and improving robustness.
> 
> ----------------------------------------------------------------
> 
> There's going to be some changes following on from this which overlap
> with ASoC, it might be simplest to merge all this stuff in via ASoC if
> that's OK?
That's fine with me. I pulled it anyway to keep mfd-next in sync with the ASoC
tree as far as MFD is concerned, and avoid potential merge conflicts.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
