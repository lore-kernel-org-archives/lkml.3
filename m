Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaLCF6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:58:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52030 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaLCF57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:57:59 -0500
Message-ID: <547EA65C.2010605@ti.com>
Date: Wed, 3 Dec 2014 11:27:48 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the usb tree
References: <20141201191923.6366f9b5@canb.auug.org.au> <20141202181230.GD11700@kroah.com>
In-Reply-To: <20141202181230.GD11700@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tuesday 02 December 2014 11:42 PM, Greg KH wrote:
> On Mon, Dec 01, 2014 at 07:19:23PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> After merging the usb tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>> arch/arm/mach-omap2/twl-common.c:94:21: error: array type has incomplete element type
>>  struct phy_consumer consumers[] = {
>>                      ^
>>
>> Caused by commit dbc98635e0d4 ("phy: remove the old lookup method").
>>
>> I have used the usb tree from next-20141128 for today.
> 
> Ick, Heikki and Kishon, do you want me to just revert this patch?  How
> did you test it?

I've resent the patch "arm: omap3: twl: remove usb phy init data" which is
needed to get rid of this error.

This patch was part of the original series sent by Heikki but I couldn't merge
it since I didn't get Ack from tony since it touched arch/arm/mach-omap2/ file.
And I clearly missed the build failure report from fengguang. Sorry.

Thanks
Kishon
