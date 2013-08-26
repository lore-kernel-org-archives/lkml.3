Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3HZVFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:05:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:1761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab3HZVFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,962,1367996400"; 
   d="scan'208";a="393705907"
Message-ID: <521BC4D7.5050507@linux.intel.com>
Date: Mon, 26 Aug 2013 14:12:55 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] HID: Win 8 multitouch panels detection in core
References: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com> <20130822175515.GA5215@polaris.bitmath.org> <alpine.LNX.2.00.1308261342430.2077@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1308261342430.2077@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 04:43 AM, Jiri Kosina wrote:
> On Thu, 22 Aug 2013, Henrik Rydberg wrote:
>
>>> this is the v3 of this patch series.
>>>
>>> Srinivas, I still did not added your tested-by as I made minors modifications of
>>> the patches 1 and 2. Now only the patch 1 will impact sensor_hub, and patch 2
>>> will not impact this. Maybe just wait for Henrik to put his "Reviewed-by" before
>>> giving one last test.
>> Here goes:
>>
>>      Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
> Thanks guys. Not applying this just yet, waiting for Tested-by: from
> Srinivas.
>
Tested-by: Srinivas Pandruvada<srinivas.pandruvada@linux.intel.com>


