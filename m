Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3HWEpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:45:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3HWEpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:45:00 -0400
Date: Thu, 22 Aug 2013 21:46:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] [BUGFIX] drivers/base: fix show_mem_removable section
 count
Message-ID: <20130823044639.GA27413@kroah.com>
References: <20130823023837.GA12396@sgi.com>
 <20130823041045.GB12296@kroah.com>
 <20130823041750.GA3081@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823041750.GA3081@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:17:50PM -0500, Russ Anderson wrote:
> On Thu, Aug 22, 2013 at 09:10:45PM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Aug 22, 2013 at 09:38:38PM -0500, Russ Anderson wrote:
> > > "cat /sys/devices/system/memory/memory*/removable" crashed the system.
> > 
> > On what kernels?  linux-next or Linus's tree, or 3.10.y?
> 
> Linus 3.11-rc6

So 3.10 is ok?  Trying to figure out where to send the fix to, thanks.

greg k-h
