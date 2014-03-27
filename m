Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaC0BJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:09:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:49181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbaC0BJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:09:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,738,1389772800"; 
   d="scan'208";a="507743084"
Message-ID: <53337A2C.9020805@linux.intel.com>
Date: Thu, 27 Mar 2014 09:09:00 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: misc: Add driver for Intel Bay Trail GPIO buttons
References: <533259F7.3050908@linux.intel.com> <53325F30.4030006@linux.intel.com> <20140326170404.47a6380a@alan.etchedpixels.co.uk> <20140326202029.GB11013@core.coreip.homeip.net>
In-Reply-To: <20140326202029.GB11013@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2014 4:20 AM, Dmitry Torokhov wrote:
> On Wed, Mar 26, 2014 at 05:04:04PM +0000, One Thousand Gnomes wrote:
>> On Wed, 26 Mar 2014 13:01:36 +0800
>> "Zhu, Lejun" <lejun.zhu@linux.intel.com> wrote:
>>
>>> This patch adds support for the GPIO buttons on some Intel Bay Trail
>>> tablets originally running Windows 8. The ACPI description of these
>>> buttons follows "Windows ACPI Design Guide for SoC Platforms".
>>
>> I'm not sure calling it "Baytrail" is right here - it's in theory a
>> generic interface so probably should be named accordingly
>>
>> Otherwise looks good to me.
> 
> It uses static devices in non-board code - if I unbind and rebind PNP
> device that produces gpio-keys platform devices driver core will not be
> happy.
> 
> Thanks.
> 

Alan, I will think of a better name for it. This is supposed to work for
other "win8 ready" tablets as well, just all I have today are Baytrail
tablets.

Dmitry, thank you for pointing out the bug. I'll fix it and submit again.

Thanks.
Lejun
