Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3BORqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:46:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:15737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab3BORqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:46:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,674,1355126400"; 
   d="scan'208";a="286331259"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: linux-next: build failure after merge of the xen-two tree
Thread-Topic: linux-next: build failure after merge of the xen-two tree
Thread-Index: AQHOC4wOTyBHFMmDoE2LH83uWllZQ5h7KthA
Date: Fri, 15 Feb 2013 17:46:48 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FC036@SHSMSX101.ccr.corp.intel.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
	<20130215132624.GB11777@phenom.dumpdata.com>
	<20130216005014.c8ce70e041f655d4c195c9fb@canb.auug.org.au>
	<2185970.g9YrD945My@vostro.rjw.lan>
 <20130216015200.1e58bec1aff05592ac2ae98f@canb.auug.org.au>
In-Reply-To: <20130216015200.1e58bec1aff05592ac2ae98f@canb.auug.org.au>
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

Stephen Rothwell wrote:
> Hi Rafael,
> 
> On Fri, 15 Feb 2013 15:53:34 +0100 "Rafael J. Wysocki" <rjw@sisk.pl>
> wrote: 
>> 
>> On Saturday, February 16, 2013 12:50:14 AM Stephen Rothwell wrote:
>>> 
>>> On Fri, 15 Feb 2013 08:26:24 -0500 Konrad Rzeszutek Wilk
>>> <konrad.wilk@oracle.com> wrote: 
>>>> 
>>>> Thank you. I keep on forgetting - but would it be OK for me to
>>>> take this patch in my tree? Or should I not since this is a new
>>>> functionality that Rafael is going to introduce in v3.9?
>>> 
>>> It is an API change in the pm tree that is not yet in Linus' tree.
>>> 
>>>> And if so, perhaps I should tack it on in my tree, once Rafael
>>>> does a git pull to Linus? Or just point Linus to this git commit?
>>> 
>>> You should point Linus at this patch if the pm tree is merged
>>> first, or 
>>> Rafael should do the same if the reverse happens.
>> 
>> Alternatively, Konrad can pull the acpi-scan branch containing the
>> changes in question from my tree into his tree and rebase the new
>> material on top of that.
> 
> Or pull the acpi-scan branch into his tree and use my conflict
> resolution in the resulting merge thus requiring no rebasing. 
> However, Linus likes to see such interactions, so it can be left up
> to when the latter of the two tress is merged by Linus.

Per my understanding, currently in git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git, it has included
1). 636458de36f1, 0cd6ac52b333, b8bd759acd05: 	from pm tree (Rafael), drop acpi_bus_add, update argument of acpi_bus_scan
2). 259f201cb7ea, 181232c249f0:			from xen tree (Jinsong), use acpi_bus_add
3). 36bd3c64bfe2					Stephen fix confliction of 1) and 2)
Currently these are only some compiling warning left, so the only thing need to do is to add my patch to fix compile warning (just sent out minutes ago) to the top of git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git ?


Thanks,
Jinsong