Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIYIPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:15:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:51878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaIYIPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:15:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="608332877"
Date: Thu, 25 Sep 2014 13:16:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Ben Skeggs <bskeggs@redhat.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Chris Ball <chris@printf.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, "Du, Wenkai" <wenkai.du@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>, intel-gfx@lists.freedesktop.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Jani Nikula <jani.nikula@intel.com>, Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        patches@opensource.wolfsonmicro.com,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Clark <robdclark@gmail.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Thierry Reding <treding@nvidia.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 00/27] add pm_runtime_last_busy_and_autosuspend() helper
Message-ID: <20140925074607.GV24663@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <6374313.I12loOK9hA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6374313.I12loOK9hA@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:28:07PM +0200, Rafael J. Wysocki wrote:
> 
> OK, I guess this is as good as it gets.
> 
> What tree would you like it go through?

Since rest of the patches are dependent upon 1st patch which should go thru
your tree, we should merge this thru your tree

Thanks
-- 
~Vinod

