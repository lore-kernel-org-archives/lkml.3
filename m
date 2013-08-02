Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3HBXpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:45:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:32622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3HBXpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:45:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,804,1367996400"; 
   d="scan'208";a="381045620"
Message-ID: <51FC4635.1040909@linux.intel.com>
Date: Fri, 02 Aug 2013 16:52:21 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC v01 0/3] Power Capping Framework
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com> <20130802222909.GA28831@kroah.com>
In-Reply-To: <20130802222909.GA28831@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:29 PM, Greg KH wrote:
> On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
>> - A uniform sys-fs interface for all devices which can offer power capping
> There is no "-" in sysfs please.
OK.
>> - A common API for drivers, which will avoid code duplication and easy
>> implementation of client drivers.
>>
>> Once this framework is approved, we will submit a RAPL client driver using this
>> framework.
> No, you need users of a framework in order for it to be approved, we
> don't add infrastructure without users.
>
> Especially as what usually happens is, when you add actual users, the
> framework changes to fix the bugs found in it :)
I will post the one client driver, which is already using this framework 
as this series.
> Ideally you will have more than one client driver submitted, as a
> "framework" for just one driver seems a bit odd, don't you think?
There are other groups and vendors interested in using this framework. 
But they want to make sure that this
framework can go to upstream Linux. We will provide one client using 
this framework at this time.
Do you think this is a problem?
> Also, you add lots of new sysfs files, those need to be documented in
> Documentation/ABI/ with this series.
I have a Documentation patch, which describes ABI and framework. It is 
under Documentation/powercap.
Do I need to move this to Documentation/ABI?
> thanks,
>
> greg k-h
Thanks,
Srinivas

