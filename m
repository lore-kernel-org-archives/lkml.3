Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3HBX40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:56:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:54876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3HBX4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="356541206"
Message-ID: <51FC48DE.2040000@linux.intel.com>
Date: Fri, 02 Aug 2013 17:03:42 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Brown, Len" <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC v01 0/3] Power Capping Framework
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com> <20130802223020.GB28831@kroah.com>
In-Reply-To: <20130802223020.GB28831@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:30 PM, Greg KH wrote:
> On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
>> Once this framework is approved, we will submit a RAPL client driver using this
>> framework.
> Also, given that you work with a lot of kernel developers, I would like
> to see their review and signed-off-by: on these patches before you
> resend them, please.  That way I know that they agree with this
> framework as a way for their future changes in this area.
The framework was presented internally number of times to Intel Linux 
Architects (including Rafael, Len Brown  and Arjan (copied in this email)).
Actual implementation, was reviewed by few developers. But I am 
expecting lots of positive/negative feedback on implementation
from community.
> thanks,
>
> greg k-h
>
Thanks,
Srinivas
