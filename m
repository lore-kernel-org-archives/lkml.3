Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3F0RDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3F0RDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:03:21 -0400
Date: Thu, 27 Jun 2013 13:03:12 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs triggered lockdep WARN.
Message-ID: <20130627170312.GA17728@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20130627145824.GA21540@redhat.com>
 <20130627150130.14981.39849@localhost.localdomain>
 <20130627151922.GA1438@redhat.com>
 <20130627153857.14981.14731@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627153857.14981.14731@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:38:57AM -0400, Chris Mason wrote:
 > >  > I really hope you don't already have CONFIG_DEBUG_PAGE_ALLOC turned on,
 > >  > maybe it will catch this?
 > > 
 > > I do. Though given this is lockdep complaining about what looks like
 > > memory corruption, it's probably not related.
 > 
 > Ok, could you please try this with some heavy memory pressure?  I'm
 > hoping to trigger a use-after-free that points us in the right
 > direction.

Have anything in particular in mind ? I tried a make -j on a kernel tree
in a loop, but nothing new is shaking out.

	Dave

