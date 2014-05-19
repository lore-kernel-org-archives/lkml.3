Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaESLxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:53:32 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50855 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbaESLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:53:31 -0400
Message-ID: <1400500408.2007.29.camel@x220>
Subject: Re: [PATCH] arm: msm: remove board file for Nexus One (ie. mahimahi)
From: Paul Bolle <pebolle@tiscali.nl>
To: dwalker@fifo99.com
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 13:53:28 +0200
In-Reply-To: <20140515215726.GA1171@fifo99.com>
References: <1400101656.9826.4.camel@x220>
	 <20140515174448.GA31159@fifo99.com> <1400177413.11786.11.camel@x220>
	 <20140515215726.GA1171@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2014 11:53:28.0785 (UTC) FILETIME=[F2FA7410:01CF7358]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Thu, 2014-05-15 at 21:57 +0000, dwalker@fifo99.com wrote:
> On Thu, May 15, 2014 at 08:10:13PM +0200, Paul Bolle wrote:
> > This is not something I get to decide. Nevertheless, given that this
> > file shouldn't have been merged to begin with, I'd appreciate it if some
> > deadline could be agreed upon.
> 
> I think I merged it actually, but there's no rules about what gets merged. How when what order, etc.
> It's all free form.

There do not seem to be formal rules. But there surely are some
requirements for code to be added. One of the requirements is, I think,
that it should build. This file cannot be built: it is not wired into a
Makefile and it also includes, what appears to be, its own header file,
but that header is not part of the tree.

Even the most dubious of code in drivers/staging is expected to "compile
properly"!

> > That being said, I'm not sure how having just this file in mainline
> > helps your development efforts. It seems it did receive some updates
> > for, well, treewide stuff. But it surely didn't get build coverage or
> > runtime testing. So would you lose much if it only remains in your
> > development tree?
> 
> It's effort to remove it.. Your asking for it to get removed, then re-added.. That sounds
> like a fairly large amount of effort vs just leaving it in place.

Yes, it takes some effort to remove code. And it will also take effort
to re-add that code later. But I think that's a risk one runs with code
that has clearly never been buildable.


Paul Bolle

