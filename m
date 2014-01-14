Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaANVk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:40:27 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37156 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaANVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:40:23 -0500
X-Originating-IP: 173.246.103.110
Date: Tue, 14 Jan 2014 13:40:15 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Michal Marek <mmarek@suse.cz>, gregkh@linux-foundation.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile: Build with -Werror=date-time if the
 compiler supports it
Message-ID: <20140114214014.GA10837@jtriplet-mobl1>
References: <cover.1387833347.git.josh@joshtriplett.org>
 <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
 <52C6E814.7090301@suse.cz>
 <20140103202915.GB12111@leaf>
 <52C723B4.1080902@suse.cz>
 <20140103210030.GE12111@leaf>
 <52D5A495.80500@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5A495.80500@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:56:53PM +0100, Michal Marek wrote:
> Dne 3.1.2014 22:00, Josh Triplett napsal(a):
> > On Fri, Jan 03, 2014 at 09:55:16PM +0100, Michal Marek wrote:
> >> On 3.1.2014 21:29, Josh Triplett wrote:
> >>> Please feel free to take the entire series through your tree; I received
> >>> some maintainer acks, but no indications that the patches are going
> >>> through their trees.
> >>
> >> OK. I will wait until mid next week and commit with any acks received.
> > 
> > Thanks!
> 
> I did not find time last week and Greg was faster and merged the driver
> patches. But I'm reluctant to only merge the Makefile patch now, because
> the kbuild branch would not build. I think I will send the patch to
> Linus after 3.14-rc1.

Greg, if you already have all the driver patches in your tree, perhaps
you could go ahead and take the Makefile patch through your tree as
well?  (Assuming that's OK with you, Michal?)

- Josh Triplett
