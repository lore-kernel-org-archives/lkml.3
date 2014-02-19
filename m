Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaBSOMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:12:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:36684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaBSOMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:12:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="scan'208";a="484058745"
Message-ID: <5304BBB9.9010205@linux.intel.com>
Date: Wed, 19 Feb 2014 22:12:09 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        David Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nouveau, ACPI: fix regression caused by b072e53
References: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com> <5304838B.4040500@canonical.com>
In-Reply-To: <5304838B.4040500@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/2/19 18:12, Maarten Lankhorst wrote:
> op 19-02-14 05:53, Jiang Liu schreef:
>> On some platforms, ACPI _DSM method (nouveau_op_dsm_muid, function 0)
>> has special requirements on the fourth parameter, which is different
>> from ACPI specifications. So revert to the private implementation
>> to check availability of _DSM functions instead of using common
>> acpi_check_dsm() interface.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>> Hi Maarten,
>>     Thanks for bisecting. Could you please help to verify whether
>> this patch fixes the regression?
>>
> Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> 
> I was wrong about the operator precedence, seems correct after all. :-)
Hi Maarten,
	Thanks for testing.
Cheers!
Gerry
