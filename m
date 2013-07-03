Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3GCIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:25:56 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:42998 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab3GCIZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:25:54 -0400
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130629023703.GA12849@roeck-us.net>
Date: Wed, 3 Jul 2013 11:25:45 +0300
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <53DF7CF6-DCD5-44F9-B535-21290E34D65D@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <20130629023703.GA12849@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

https://github.com/pantoniou/linux-beagle-track-mainline

Against tip of the mainline, topic branches against the master,
and a merge-branch every time I do one.

Regards

-- Pantelis

On Jun 29, 2013, at 5:38 AM, Guenter Roeck wrote:

> On Fri, Jan 04, 2013 at 09:31:04PM +0200, Pantelis Antoniou wrote:
>> The following patchset introduces Device Tree overlays, a method
>> of dynamically altering the kernel's live Device Tree.
>> 
>> This patchset is against mainline as of Friday Jan 4 2013.
>> (4956964 Merge tag 'driver-core-3.8-rc2' of \
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
>> 
>> Note that a separate patch for the DTC compiler has been posted and
>> is required to compile the DTS files according to the documentation.
>> The patch is "dtc: Dynamic symbols & fixup support"
>> 
>> An implementation patchset for a beaglebone cape loader will follow,
>> but if you want to check out a working kernel for the beaglebone please
>> pull from:
>> 
>> git://github.com/pantoniou/linux-bbxm.git branch not-capebus-v8
>> 
>> Pantelis Antoniou (6):
>>  OF: Introduce device tree node flag helpers.
>>  OF: export of_property_notify
>>  OF: Export all DT proc update functions
>>  OF: Introduce utility helper functions
>>  OF: Introduce Device Tree resolve support.
>>  OF: Introduce DT overlay support.
>> 
> Hi Pantelis,
> 
> do you have an update of this patchset ? I want to seriously start testing it.
> Digging through your tree on github is a bit cumbersome, and I am not sure
> if I got all patches. It would also be nice to get an update with all the
> comments addressed.
> 
> Thanks,
> Guenter

