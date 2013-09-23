Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3IWOKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:10:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37186 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3IWOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:10:44 -0400
Message-ID: <52404BD6.9070101@cogentembedded.com>
Date: Mon, 23 Sep 2013 18:10:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Roger Quadros <rogerq@ti.com>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-9-git-send-email-rogerq@ti.com> <523F3567.80303@cogentembedded.com> <20130922214859.GC27616@mtj.dyndns.org>
In-Reply-To: <20130922214859.GC27616@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/23/2013 01:48 AM, Tejun Heo wrote:

>>> @@ -37,6 +37,7 @@

>>>   #include <linux/clk.h>
>>>   #include <linux/libata.h>
>>> +#include <linux/phy/phy.h>

>> struct phy;

>> should suffice.

> Unless it's actually likely to cause inclusion loop, I think it's
> better to include the header than adding explicit declarations.

    Apparently, tastes differ here. E.g. Greg KH would have also told Roger to 
use forward declaration in such case. :-)

> Thanks.

WBR, Sergei

