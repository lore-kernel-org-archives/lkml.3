Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3IWMOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:14:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:2535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3IWMOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:14:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="399691618"
Date: Mon, 23 Sep 2013 20:14:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
Message-ID: <20130923121402.GA12626@localhost>
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

Yeah it fixed the problem: no more oops in 1000 kernel boot tests. Thank you!

Cheers,
Fengguang
