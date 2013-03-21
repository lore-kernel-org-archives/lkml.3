Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3CUKWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:22:10 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43680 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3CUKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:22:08 -0400
Date: Thu, 21 Mar 2013 11:22:01 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC 1/5] kconfig: implement weak reverse-dependencies
Message-ID: <20130321102200.GB2341@netboy.at.omicron.at>
References: <20130321082256.21557.68351.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321082256.21557.68351.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:22:57PM +0400, Konstantin Khlebnikov wrote:
> This patch adds new kind of dependencies between kconfig symbols,
> and new kconfig keyword 'apply' for them.
> 
> 'apply' works mostly like 'select', but it allows to disable target symbol.
> Thus target symbol will be either disabled or reachable from current symbol.
> 
> This method allows to implement optional dependencies without introducing new
> kconfig symbol for each pair of connected kconfig options.

I don't really understand what the point of this new keyword is, but I
wonder why you chose PTP Hardware Clocks as your Guinea pig.

As discussed on the netdev list [1][2], the consensus was that if a
MAC driver has a PHC, then it should always be compiled in.

And BTW, please CC netdev for PHC patches.

Thanks,
Richard

1. http://marc.info/?l=linux-netdev&m=135173341101960
2. http://www.spinics.net/lists/netdev/msg215379.html
