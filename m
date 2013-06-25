Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3FYQuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:50:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:47002 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3FYQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:50:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="322388355"
Date: Tue, 25 Jun 2013 21:40:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH v2 05/12] dmaengine: PL08x: Add support for
 different maximum transfer size
Message-ID: <20130625161003.GQ23141@intel.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
 <1371933764-24875-6-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371933764-24875-6-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 10:42:37PM +0200, Tomasz Figa wrote:
> PL080S has separate register to store transfer size in, allowing single
> transfer to be much larger than in standard PL080.
> 
> This patch makes the amba-pl08x driver aware of this and removes writing
> transfer size to reserved bits of CH_CONTROL register on PL080S, which
> was not a problem witn transfer sizes fitting the original bitfield
> of PL080, but now would overwrite other fields.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Acked by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
