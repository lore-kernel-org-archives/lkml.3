Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaJECM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 22:12:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaJECM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 22:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,656,1406617200"; 
   d="scan'208";a="583629522"
Date: Sun, 5 Oct 2014 10:13:36 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141005021335.GA14640@shldeISGChi005.sh.intel.com>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140930100720.45625804@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930100720.45625804@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:07:20AM +0200, Boris Brezillon wrote:
> Hi,
> 
> On Tue, 23 Sep 2014 16:07:33 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> 
> > Hello Huang, Brian,
> > 
> > This is just a new proposal to support raw accesses in a more standard way
> > in the GPMI driver.
> > This series has been tested on an imx28 board.
> > 
> > Any suggestions are welcome.
> 
> Brian, any chance you could take a look at this series and give your
> opinion and/or suggest a new approach ?
> 
> Huang, did you have time to think about a better way to implement these
> raw access functions ?
> 
sorry for the later reply. I was busy recently.
You can send out the new version. Please do not forget add a patch to
add
more comments for these hooks.

I will test your patch(or your new patch set) on Oct 7 and Oct 8.

thanks
Huang Shijie
