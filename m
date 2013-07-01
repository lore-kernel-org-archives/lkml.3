Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3GAJyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:54:36 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:49058 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab3GAJyf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:54:35 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 05:54:35 EDT
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130629023703.GA12849@roeck-us.net>
Date: Mon, 1 Jul 2013 12:46:24 +0300
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <572C690B-5C1F-4480-812E-195724708ADA@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <20130629023703.GA12849@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Yes there is an updated patchset against 3.10 as of this morning.

I will post details how to get it later today.

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

