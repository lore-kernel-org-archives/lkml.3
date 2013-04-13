Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3DMDFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 23:05:14 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49666 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3DMDFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 23:05:12 -0400
Date: Fri, 12 Apr 2013 20:05:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH PART2 v2 2/7] staging: ramster: Move debugfs code out of
 ramster.c file
Message-ID: <20130413030507.GA17584@kroah.com>
References: <1365730287-16876-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1365730287-16876-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130412221603.GA11282@kroah.com>
 <20130412221744.GA11340@kroah.com>
 <5168a707.22e7420a.160b.ffffc573SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5168a707.22e7420a.160b.ffffc573SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 08:29:39AM +0800, Wanpeng Li wrote:
> On Fri, Apr 12, 2013 at 03:17:44PM -0700, Greg Kroah-Hartman wrote:
> >On Fri, Apr 12, 2013 at 03:16:03PM -0700, Greg Kroah-Hartman wrote:
> >> On Fri, Apr 12, 2013 at 09:31:22AM +0800, Wanpeng Li wrote:
> >> > Note that at this point there is no CONFIG_RAMSTER_DEBUG
> >> > option in the Kconfig. So in effect all of the counters
> >> > are nop until that option gets re-introduced in:
> >> > zcache/ramster/debug: Add RAMSTE_DEBUG Kconfig entry
> >> 
> >> RAMSTE_DEBUG?  :)
> >> 
> >
> >And I fat-fingered my scripts, and deleted this email, sorry.
> >
> 
> No problem, I will send 2-7 ASAP. ;-)

Thanks.  5 years since my last email deletion, not that bad :)

greg k-h
