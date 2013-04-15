Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3DOWfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:35:44 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:55955 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3DOWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:35:42 -0400
Date: Mon, 15 Apr 2013 15:35:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Brad Spengler <spender@grsecurity.net>, linux-mtd@lists.infradead.org
Subject: Re: [ 10/11] mtdchar: fix offset overflow detection
Message-ID: <20130415223532.GB10195@kroah.com>
References: <20130415020614.067692418@linuxfoundation.org>
 <20130415020614.846683113@linuxfoundation.org>
 <1366059320.3072.65.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366059320.3072.65.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:55:20PM +0100, David Woodhouse wrote:
> On Sun, 2013-04-14 at 19:17 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> Please use f5cf8f07423b2677cebebcebc863af77223a4972 instead (for 3.4
> too).

Really?  I love the comment in that commit, "disable it for now until it
can be fixed properly in the next merge window."  Yet that was back in
October of last year, no one has actually fixed this issue, is that
because it can't be properly fixed, or just because no one got around to
it?

thanks,

greg k-h
