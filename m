Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3BUGkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:40:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:22215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3BUGke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:40:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,706,1355126400"; 
   d="scan'208";a="259662024"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: linux-next: build failure after merge of the xen-two tree
Thread-Topic: linux-next: build failure after merge of the xen-two tree
Thread-Index: AQHOD6vNTyBHFMmDoE2LH83uWllZQ5iD3SCA
Date: Thu, 21 Feb 2013 06:40:29 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923354024BB@SHSMSX101.ccr.corp.intel.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
 <11850955.SHqxVBsJqI@vostro.rjw.lan>
 <DE8DF0795D48FD4CA783C40EC82923353FCCAC@SHSMSX101.ccr.corp.intel.com>
 <4696812.SKkpQQd9iW@vostro.rjw.lan>
 <20130220204941.GC4526@phenom.dumpdata.com>
In-Reply-To: <20130220204941.GC4526@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
>>>> commit 3757b94802fb65d8f696597a74053cf21738da0b
>>>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>> Date:   Wed Feb 13 14:36:47 2013 +0100
>>>> 
>>>>     ACPI / hotplug: Fix concurrency issues and memory leaks
>>>> 
>>>> after which acpi_bus_scan() and acpi_bus_trim() have to be run
>>>> under acpi_scan_lock (new in my tree as well).
>>> 
>>> Yes, we noticed that and only need minor updates at xen side, will
>>> send out 2 xen patches later accordingly, for cleanup and adding
>>> lock. 
>> 
>> Thanks, but those new changes will only make sense after merging the
>> Xen tree with the PM tree.  Why don't we queue them up for merging
>> later after both the Xen and PM trees have been pulled from?
> 
> OK, I've created a branch
> (http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next-resolved)
> that has your branch and my branch - along with the fix from Stephan
> and then  
> the three updates from Jinsong. Jinsong, please check that I've got
> all the 
> right patches. I will rebase it once Linus has merged both of the Xen
> and PM trees. 

Check done, it's OK.

Thanks,
Jinsong