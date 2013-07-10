Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3GJS46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:56:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:47515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab3GJS44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:56:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1037,1363158000"; 
   d="scan'208";a="367986404"
Message-ID: <51DDAE65.7040604@linux.intel.com>
Date: Wed, 10 Jul 2013 21:56:37 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: linux-man@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
References: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com> <51DDA1DC.2020306@gmail.com>
In-Reply-To: <51DDA1DC.2020306@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 21:03, Michael Kerrisk wrote:
> On 07/10/13 16:18, Eliezer Tamir wrote:
>> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
> 
> What's the status of this feature. A quick grep seems to show
> that the feature is not yet in mainline. What is the plan?

The basic code is already in Linus' tree. there were request to rename
things. The current name for the socket option is SO_LL but a patche to
rename it to SO_BUSY_POLL were sent to net-dev.

http://patchwork.ozlabs.org/patch/258065/

If you want me to notify you when the change hits Linus' tree I can do that.

-Eliezer
