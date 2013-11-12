Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3KLVoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:44:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:62794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3KLVnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:43:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,687,1378882800"; 
   d="scan'208";a="426457940"
Message-ID: <5282A222.5020702@linux.intel.com>
Date: Tue, 12 Nov 2013 13:48:18 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: ohad@wizery.com
CC: linux-kernel@vger.kernel.org, Jocelyn Falempe <jocelyn.falempe@intel.com>
Subject: Re: [PATCH] rpmsg: reduce rpmsg_virtio verbosity
References: <1380825415-20481-1-git-send-email-david.a.cohen@linux.intel.com> <525EBBAA.9000209@linux.intel.com>
In-Reply-To: <525EBBAA.9000209@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/16/2013 09:15 AM, David Cohen wrote:
> On 10/03/2013 11:36 AM, David Cohen wrote:
>> From: Jocelyn Falempe <jocelyn.falempe@intel.com>
>>
>> rpmsg_virtio TX/RX messages are very verbose, overflowing kernel printk
>> buffer. This patch makes the guilty print_hex_dump()'s to act as
>> dev_dbg() and do nothing in case neither DEBUG nor CONFIG_DYNAMIC_DEBUG
>> are defined.
>>
>> Signed-off-by: Jocelyn Falempe <jocelyn.falempe@intel.com>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>
> Ping :)
> Comments here?

Ping again :)

>
> Br, David Cohen
>

