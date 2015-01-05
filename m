Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbbAEIzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:55:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:23946 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbbAEIz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:55:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="436522422"
Message-ID: <54AA51F0.20706@intel.com>
Date: Mon, 05 Jan 2015 10:57:20 +0200
From: Daniel Baluta <daniel.baluta@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 03/10] iio: imu: kmx61: Enhance error handling
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-4-git-send-email-daniel.baluta@intel.com> <54A54FE2.1020407@gmx.de> <54A919D5.2000408@kernel.org>
In-Reply-To: <54A919D5.2000408@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/04/2015 12:45 PM, Jonathan Cameron wrote:
> On 01/01/15 13:47, Hartmut Knaack wrote:
>> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>>> This fixes parts of kmx61 error handling to make code easier to read and to be
>>> more consistent with IIO coding conventions:
>>> 	* prefer as single point for error handling instead of duplicating code
>>> 	for each function
>>> 	* directly return a value from a case branch instead of breaking
>>> 	* fix error message for writing REG_CTRL1
>>>
>>> Also, add separate error paths for kmx61_trigger_setup/iio_triggered_buffer_setup
>>> calls.
>> Some issues remain in this one, please see inline. Otherwise looking good.
>>
> Fixed up and applied.

Thanks for doing this Jonathan.

Daniel.
