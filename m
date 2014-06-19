Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbaFSGdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:33:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:55117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaFSGdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,505,1400050800"; 
   d="scan'208";a="550202693"
Message-ID: <53A28408.8040001@intel.com>
Date: Thu, 19 Jun 2014 14:32:40 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sorin Manolache <sorinm@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: drivers/acpi/ac.c, re-enabling CONFIG_ACPI_PROCFS_POWER?
References: <53A1F65C.9090907@gmail.com> <1891948.UFv8RnVsZc@vostro.rjw.lan>
In-Reply-To: <1891948.UFv8RnVsZc@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月19日 07:17, Rafael J. Wysocki wrote:
> On Wednesday, June 18, 2014 10:28:12 PM Sorin Manolache wrote:
>> Hello,
>>
>> Would it be worth considering re-enabling the old procfs interface for 
>> ac.c? There are old tools still around (kpowersave from kde 3.5.10) that 
>> expect /proc/acpi/ac_adapter.
> 
> Can you please CC ACPI-related messages to linux-acpi@vger.kernel.org?
> 
> I'm not sure how much effort that would require at this point.  Rui, Tianyu?

I think we need to revert commit ab0fd67.

commit ab0fd674d6cef0904baa511f22613ef6474f8169
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Sat Oct 12 21:04:48 2013 +0800

    ACPI / AC: Remove AC's proc directory.

    AC's proc directory is not used and so remove it. Prepare for removing
    /proc/acpi directory.

    Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


> 
> Rafael
> 


-- 
Best regards
Tianyu Lan
