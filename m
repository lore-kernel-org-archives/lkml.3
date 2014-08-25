Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaHYIRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:17:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:28932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbaHYIRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="581242054"
Date: Mon, 25 Aug 2014 11:17:07 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/6] phy: remove the old lookup method
Message-ID: <20140825081707.GA21712@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-5-git-send-email-heikki.krogerus@linux.intel.com>
 <CAFp+6iEihFwvJA7qkdhkGrSGkgEZz4Qtm4CAU6h0Aq3zUt1bxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iEihFwvJA7qkdhkGrSGkgEZz4Qtm4CAU6h0Aq3zUt1bxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 01:11:34PM +0530, Vivek Gautam wrote:
> Please squash the attached diff which removes the 'init_data' field
> from some of the other instances
> of devm_phy_create() in few other drivers.
> This should prevent any build errors that i could see with multi_v7_defconfig.

OK, I'll add those changes into this patch, and it seems there
is now at least one more new driver on top of those calling
devm_phy_create.


Thanks!

-- 
heikki
