Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3COQrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:47:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:3708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3COQrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,852,1355126400"; 
   d="scan'208";a="271384371"
Date: Fri, 15 Mar 2013 17:46:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH 2/3] mfd: Make AB8500_CORE select POWER_SUPPLY to fix
 build error
Message-ID: <20130315164657.GA29606@zurbaran>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-2-git-send-email-arnd@arndb.de>
 <20130315064436.GD12559@zurbaran>
 <201303151018.13518.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303151018.13518.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Mar 15, 2013 at 10:18:13AM +0000, Arnd Bergmann wrote:
> On Friday 15 March 2013, Samuel Ortiz wrote:
> > On Thu, Mar 14, 2013 at 10:56:39PM +0100, Arnd Bergmann wrote:
> > > 
> > > Please apply to MFD tree for 3.9
> > Already applied to mfd-fixes.
> > 
> 
> For some reason I did not see it when I rebased my patches on top of linux-next
> to make sure I don't send any patches again that are already queued up.
> 
> Is there a reason why mfd-fixes is not part of linux-next?
No valid reasons, you're right. I'll ping Stephen about it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
