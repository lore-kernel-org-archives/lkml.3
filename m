Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaCGRqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:46:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52661 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaCGRqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:46:20 -0500
Message-ID: <531A05E2.8080706@ti.com>
Date: Fri, 7 Mar 2014 23:16:10 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v6] phy: omap-usb2: move omap_usb.h from linux/usb/ to
 linux/phy/
References: <1393846695-14644-1-git-send-email-kishon@ti.com> <1394210888-1587-1-git-send-email-kishon@ti.com> <20140307165043.GC23885@saruman.home> <531A0436.3080201@ti.com> <20140307174059.GD23885@saruman.home>
In-Reply-To: <20140307174059.GD23885@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014 11:10 PM, Felipe Balbi wrote:
> On Fri, Mar 07, 2014 at 11:09:02PM +0530, Kishon Vijay Abraham I wrote:
>> On Friday 07 March 2014 10:20 PM, Felipe Balbi wrote:
>>> On Fri, Mar 07, 2014 at 10:18:08PM +0530, Kishon Vijay Abraham I wrote:
>>>> No functional change. Moved omap_usb.h from linux/usb/ to linux/phy/.
>>>> Also removed the unused members of struct omap_usb (after phy-omap-pipe3
>>>> started using it's own header file)
>>>
>>> does this depend in any other patch ? I get the following when applying
>>> *only* this patch on top of v3.14-rc5:
>>
>> yeah.. this is for linux-phy tree. I'll take this patch.
>
> looks like you're doing two things at once (renaming the header and
> removing some unnecessary fields). At least mention the second thing.

The second line of the commit message mentions just that ;-)

Regards
Kishon
