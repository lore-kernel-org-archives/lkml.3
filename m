Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3CEJ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:57:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:64391 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3CEJ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="scan'208";a="294979636"
Date: Tue, 5 Mar 2013 17:57:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/gadget: initialize gadget functions helper befor
 functions & gadgets
Message-ID: <20130305095734.GA30166@localhost>
References: <20130206020424.GB1175@localhost>
 <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:28:09PM +0100, Sebastian Andrzej Siewior wrote:
> Fengguang Wu run into a kernel ops after he complied dummy_hcd and g_cdc
> into the kernel. The problem was that u_serial was used by g_cdc before
> u_serial was initialized. In the module case eveything is initialized in
> the correct order but if we compile it into the kernel we rely on
> Makefile order which I did wrong and now I correct this.
> 
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!
