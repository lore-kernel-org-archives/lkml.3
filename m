Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaLaKYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 05:24:00 -0500
Received: from sauhun.de ([89.238.76.85]:43309 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLaKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 05:23:58 -0500
Date: Wed, 31 Dec 2014 11:23:50 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 06/28] dma: drop owner assignment from platform_drivers
Message-ID: <20141231102350.GB1461@katana>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-7-git-send-email-wsa@the-dreams.de>
 <20141222153822.GP16827@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222153822.GP16827@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 09:08:22PM +0530, Vinod Koul wrote:
> On Sun, Dec 21, 2014 at 10:14:27PM +0100, Wolfram Sang wrote:
> > This platform_driver does not need to set an owner, it will be populated by the
> > driver core.
> > 
> After susbstem name if fixed
> 
> Acked-by: Vinod Koul <vinod.koul@intel.com>

Since I'd prefer this to go via your tree, can you fix it or shall I
resend?

