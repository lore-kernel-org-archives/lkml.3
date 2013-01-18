Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3ARO3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:29:55 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37691 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3ARO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130118142251.GL4672@arwen.pp.htv.fi>
References: <1357916550-11421-3-git-send-email-gautam.vivek@samsung.com>
	<1358166135-22073-1-git-send-email-gautam.vivek@samsung.com>
	<20130118131633.GJ4672@arwen.pp.htv.fi>
	<CAFp+6iF9H+n1Fwr89es-jtDAN=ht1PuXQER9vQ=jG2RZQTceWw@mail.gmail.com>
	<20130118142251.GL4672@arwen.pp.htv.fi>
Date: Fri, 18 Jan 2013 19:59:52 +0530
Message-ID: <CAFp+6iE5gU5QrheYyHLV2yfO=d3j3fVA7qq8CQ4KLysjXFRh3w@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] usb: phy: samsung: Add host phy support to
 samsung-phy driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Balbi,


On Fri, Jan 18, 2013 at 7:52 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Jan 18, 2013 at 07:51:08PM +0530, Vivek Gautam wrote:
>> Hi Felipe,
>>
>>
>> On Fri, Jan 18, 2013 at 6:46 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Mon, Jan 14, 2013 at 05:52:15PM +0530, Vivek Gautam wrote:
>> >> This patch adds host phy support to samsung-usbphy driver and
>> >> further adds support for samsung's exynos5250 usb-phy.
>> >>
>> >> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >
>> > Missing Kukjim's Acked-by here
>> >
>>
>> Hope you are fine with the changes happened after discussion in thread:
>> [PATCH v5 2/4] usb: phy: samsung: Add host phy support to samsung-phy driver
>>
>> Is it something you want me to modify in this patch ?
>
> please send the final patch and we shall see. After quickly browsing
> that thread, I didn't see anything scary, but I'd like to see your final
> version before giving my final answer ;-)
>

this series of patch is the final version from my side unless Doug or
you have any further comments
on the thread :
https://lkml.org/lkml/2013/1/14/481

Seems like Doug wanted to know your opinion in this regard. ;-)



-- 
Thanks & Regards
Vivek
