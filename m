Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaEOR7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:59:44 -0400
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:50589
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755717AbaEOR7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:59:42 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 13:59:42 EDT
Date: Thu, 15 May 2014 17:44:48 +0000
From: dwalker@fifo99.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: msm: remove board file for Nexus One (ie. mahimahi)
Message-ID: <20140515174448.GA31159@fifo99.com>
References: <1400101656.9826.4.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400101656.9826.4.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:07:36PM +0200, Paul Bolle wrote:
> Commit 1b802ff79f03 ("arm: msm: add board file for Nexus One (ie.
> mahimahi)") added just board-mahimahi.c. It did not add
> board-mahimahi.h, Makefile changes or Kconfig changes.
> 
> Four years have passed and this file is still dangling. Remove it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. But what to test here?
> 

I don't mine if Sapphire gets removed, but I'm working on this one now.. So I don't want it deleted.

Daniel
