Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3HAWN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:13:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:3657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab3HAWNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="380344143"
Message-ID: <51FADD6F.3040804@linux.intel.com>
Date: Thu, 01 Aug 2013 15:13:03 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com> <20130725234007.GB18349@kroah.com> <20130726144251.GB4379@variantweb.net> <20130801205724.GA13585@kroah.com>
In-Reply-To: <20130801205724.GA13585@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 01:57 PM, Greg Kroah-Hartman wrote:
>> > "memory" is the name used by the current sysfs memory layout code in
>> > drivers/base/memory.c. So it can't be the same unless we are going to
>> > create a toggle a boot time to select between the models, which is
>> > something I am looking to add if this code/design is acceptable to
>> > people.
> I know it can't be the same, but this is like "memory_v2" or something,
> right?  I suggest you make it an either/or option, given that you feel
> the existing layout just will not work properly for you.

If there are existing tools or applications that look for memory hotplug
events, how does this interact with those?  I know you guys have control
over the ppc software that actually performs the probe/online
operations, but what about other apps?

I also don't seem to see the original post to LKML.  Did you send
privately to Greg, then he cc'd LKML on his reply?
