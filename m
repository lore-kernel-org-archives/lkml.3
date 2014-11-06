Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKFQn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:43:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55567 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaKFQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:43:27 -0500
Message-ID: <545BA513.2090907@ti.com>
Date: Thu, 6 Nov 2014 10:42:59 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tom Rini <trini@ti.com>, <balbi@ti.com>
CC: <devicetree@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <beagleboard@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <gerald@granddesignsgroup.com>, <fcooper@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15
References: <1415290702-11353-1-git-send-email-nm@ti.com> <20141106163207.GF16896@saruman> <545BA3E6.90105@ti.com>
In-Reply-To: <545BA3E6.90105@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 10:37 AM, Tom Rini wrote:

>>> device_type = "memory"; +		reg = <0x80000000 0x40000000>; /* 1GB
>>> to start. Target 2GB */
>>
>> 1GiB ? Why would you put this here btw ? u-boot fills this one up.
> 
> Yes, it should either be the full and correct value or 0x0 (like a
> number of PowerPC platforms do) so it's clear something else gives us
> the right value here.

Honest mistake, my bad.. I thought I cleaned up the patch! Sigh!!! i
will repost with proper 2GB. it is better that way in case being used
with "other bootloaders" which are not exactly too good like u-boot.


-- 
Regards,
Nishanth Menon
