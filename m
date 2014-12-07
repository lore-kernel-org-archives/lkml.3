Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaLGLsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 06:48:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:12705 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbaLGLsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 06:48:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="494977402"
Date: Sun, 7 Dec 2014 17:18:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] dmaengine: Add driver for IMG MDC
Message-ID: <20141207114829.GX3411@intel.com>
References: <1416002384-3525-1-git-send-email-abrestic@chromium.org>
 <1416002384-3525-3-git-send-email-abrestic@chromium.org>
 <20141205173553.GS3411@intel.com>
 <CAL1qeaE+7L2p=HxPBasQYLVPD0H2qBAd439Fn_z3Fza9Y3+0eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1qeaE+7L2p=HxPBasQYLVPD0H2qBAd439Fn_z3Fza9Y3+0eA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:30:53AM -0800, Andrew Bresticker wrote:
> After adding a macro for setting the WIDTH_{R,W} fields it seems fine
> to me.  Is there something else you had in mind?
I think whole of this might be a macro :)


> > and this depends on dma_slave_config being set, which shouldn't be the case
> > for memcpy
okay looking back yes it depends on bus_width. But how is bus_width set, i
thought the dma_slave_config will set that?

-- 
~Vinod

