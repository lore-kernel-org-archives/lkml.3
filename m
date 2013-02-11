Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3BKLpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:45:09 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:50376 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3BKLpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:45:07 -0500
Message-ID: <5118D9B0.5030106@synopsys.com>
Date: Mon, 11 Feb 2013 17:14:48 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 02/71] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-3-git-send-email-vgupta@synopsys.com> <5118D61D.7010302@imgtec.com>
In-Reply-To: <5118D61D.7010302@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 04:59 PM, James Hogan wrote:
> Hi Vineet,
> 
> On 24/01/13 10:50, Vineet Gupta wrote:
>> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
>> new file mode 100644
>> index 0000000..b0b09ae
>> --- /dev/null
>> +++ b/arch/arc/Kconfig
>> @@ -0,0 +1,328 @@
>> +#
>> +# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
>> +#
>> +# This program is free software; you can redistribute it and/or modify
>> +# it under the terms of the GNU General Public License version 2 as
>> +# published by the Free Software Foundation.
>> +#
>> +
>> +config ARC
>> +	def_bool y
>> +	select ARCH_NO_VIRT_TO_BUS
> 
> I noticed this in linux-next. ARCH_NO_VIRT_TO_BUS was defined
> generically in the past in linux-next but the patch seems to have gone.
> Therefore with an arc defconfig I see CONFIG_VIRT_TO_BUS=y defined which
> I'm guessing it shouldn't be.

Good catch ! I'll add a config ARCH_NO_VIRT_TO_BUS, but it would seem this is
better done in arch/Kconfig and get rid of extraneous defs in arch/*/Kconfig. I
can spin that patch, the only issue is merging logistics - our trees are not yet
apt for such changes.

Thx,
-Vineet
