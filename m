Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3HWERw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:17:52 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59522 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3HWERv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:17:51 -0400
Date: Thu, 22 Aug 2013 23:17:50 -0500
From: Russ Anderson <rja@sgi.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] [BUGFIX] drivers/base: fix show_mem_removable section
	count
Message-ID: <20130823041750.GA3081@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130823023837.GA12396@sgi.com> <20130823041045.GB12296@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823041045.GB12296@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 09:10:45PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Aug 22, 2013 at 09:38:38PM -0500, Russ Anderson wrote:
> > "cat /sys/devices/system/memory/memory*/removable" crashed the system.
> 
> On what kernels?  linux-next or Linus's tree, or 3.10.y?

Linus 3.11-rc6

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
