Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaIXS4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:56:37 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65136 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaIXS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:56:35 -0400
Message-ID: <542313DE.1080709@cogentembedded.com>
Date: Wed, 24 Sep 2014 22:56:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, Peter.Chen@freescale.com,
        stern@rowland.harvard.edu, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, balbi@ti.com, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        yoshihiro.shimoda.uh@renesas.com, linux-kernel@vger.kernel.org,
        antoine.tenart@free-electrons.com
Subject: Re: [PATCH v5 1/2] usb: rename phy to usb_phy in HCD
References: <5072811.p8odmvpxdS@wasted.cogentembedded.com> <2282553.NrZjRxyKlv@wasted.cogentembedded.com> <20140924051138.GA4440@kroah.com>
In-Reply-To: <20140924051138.GA4440@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello.

On 09/24/2014 09:11 AM, Greg KH wrote:

>> From: Antoine Tenart <antoine.tenart@free-electrons.com>

>> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
>> modifications are done in all drivers accessing it.
>> This is in preparation to adding the generic PHY support.

>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>> [Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved rejects
>> caused by patch reordering, updated changelog.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>> Acked-by: Felipe Balbi <balbi@ti.com>

>> ---
>> Changes in version 5:
>> - imported the patch from Antoine Tenart's series;
>> - added missing 'drivers/usb/misc/lvstest.c' file;
>> - resolved rejects caused by patch reordering;
>> - refreshed patch;
>> - updated changelog.

>>   drivers/usb/chipidea/host.c   |    2 +-
>>   drivers/usb/core/hcd.c        |   20 ++++++++++----------
>>   drivers/usb/core/hub.c        |    8 ++++----
>>   drivers/usb/host/ehci-fsl.c   |   16 ++++++++--------
>>   drivers/usb/host/ehci-hub.c   |    2 +-
>>   drivers/usb/host/ehci-msm.c   |    4 ++--
>>   drivers/usb/host/ehci-tegra.c |   16 ++++++++--------
>>   drivers/usb/host/ohci-omap.c  |   20 ++++++++++----------
>>   drivers/usb/misc/lvstest.c    |    8 ++++----
>>   include/linux/usb/hcd.h       |    2 +-
>>   10 files changed, 49 insertions(+), 49 deletions(-)

> This doesn't apply to my tree at all anymore,

    Well, I'm seeing only a minor reject in the first file, easily fixable.

> can you refresh it and resend?

    OK, will re-post now.

> thanks,

> greg k-h

WBR, Sergei

