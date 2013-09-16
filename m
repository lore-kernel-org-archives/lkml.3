Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3IPJuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:50:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:47787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3IPJuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:50:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="396254741"
Date: Mon, 16 Sep 2013 17:50:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
Message-ID: <20130916095013.GA13395@localhost>
References: <20130902102327.GB14264@localhost>
 <5236CC49.7000206@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236CC49.7000206@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:15:53AM +0200, Arend van Spriel wrote:
> On 09/02/2013 12:23 PM, Fengguang Wu wrote:
> >Greetings,
> >
> >I got the below dmesg and the first bad commit is
> 
> Hi Fengguang,
> 
> I could not reproduce this issue. Could you retest with the attached
> patch file applied and let me know if that fixes the problem?

Sure. I've queued the patch for testing. Will report back 1-2 days
later.

Thanks,
Fengguang
