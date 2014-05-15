Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaEOSKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:10:18 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:58336 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbaEOSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:10:16 -0400
Message-ID: <1400177413.11786.11.camel@x220>
Subject: Re: [PATCH] arm: msm: remove board file for Nexus One (ie. mahimahi)
From: Paul Bolle <pebolle@tiscali.nl>
To: dwalker@fifo99.com
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 20:10:13 +0200
In-Reply-To: <20140515174448.GA31159@fifo99.com>
References: <1400101656.9826.4.camel@x220>
	 <20140515174448.GA31159@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 18:10:13.0722 (UTC) FILETIME=[EAEB1BA0:01CF7068]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Thu, 2014-05-15 at 17:44 +0000, dwalker@fifo99.com wrote:
> On Wed, May 14, 2014 at 11:07:36PM +0200, Paul Bolle wrote:
> > Commit 1b802ff79f03 ("arm: msm: add board file for Nexus One (ie.
> > mahimahi)") added just board-mahimahi.c. It did not add
> > board-mahimahi.h, Makefile changes or Kconfig changes.
> > 
> > Four years have passed and this file is still dangling. Remove it.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested. But what to test here?
> > 
> I don't mine if Sapphire gets removed,

Could you ACK that patch, please?

>  but I'm working on this one now..

That's good to hear.

>  So I don't want it deleted.

This is not something I get to decide. Nevertheless, given that this
file shouldn't have been merged to begin with, I'd appreciate it if some
deadline could be agreed upon.

That being said, I'm not sure how having just this file in mainline
helps your development efforts. It seems it did receive some updates
for, well, treewide stuff. But it surely didn't get build coverage or
runtime testing. So would you lose much if it only remains in your
development tree?


Paul Bolle

