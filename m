Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3IBIz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:12456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab3IBIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="372152941"
Date: Mon, 2 Sep 2013 10:55:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        alsa-devel@alsa-project.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove ASoC-level I/O functions from cq93vc
Message-ID: <20130902085534.GP20329@zurbaran>
References: <20130831130741.GG18608@sirena.org.uk>
 <20130901144847.GM20329@zurbaran>
 <20130901150853.GG3084@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901150853.GG3084@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Sep 01, 2013 at 04:08:53PM +0100, Mark Brown wrote:
> On Sun, Sep 01, 2013 at 04:48:47PM +0200, Samuel Ortiz wrote:
> 
> > As I'd prefer to carry the MFD ones (Including the twl6040 one) through
> > mfd-next, I can build a branch for you to pull from. Would that be fine
> > with you ?
> 
> That's fine by me, I just want the patches in ASoC - obviously the
> branch couldn't be rebased though.
I put a topic/for-asoc branch upstream for you to pull from:

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git topic/for-asoc

for you to fetch changes up to c6f39257c952bc7da974bf93255936ff2ece2c34:

  mfd: twl6040: Use regmap for register cache (2013-09-02 10:30:14
+0200)

----------------------------------------------------------------
Mark Brown (3):
      mfd: davinci_voicecodec: Remove unused read and write functions
      mfd: davinci_voicecodec: Provide a regmap for register I/O
      mfd: twl6040: Use regmap for register cache

 drivers/mfd/davinci_voicecodec.c       |   23 +++++++++++++----------
 drivers/mfd/twl6040.c                  |   43 ++++++++++++++++++++++++++++++-------------
 include/linux/mfd/davinci_voicecodec.h |    3 +++
 include/linux/mfd/twl6040.h            |    1 -
 4 files changed, 46 insertions(+), 24 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
