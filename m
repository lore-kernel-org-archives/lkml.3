Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3FYAW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:22:58 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62826 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FYAWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:22:55 -0400
Message-ID: <51C8E2D9.2070304@gmail.com>
Date: Tue, 25 Jun 2013 08:22:49 +0800
From: Peng Tao <bergwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au> <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com> <20130624224035.GD24099@kroah.com> <20130625094051.b9cf8f8950eeeeed0dd266b2@canb.auug.org.au> <20130624235003.GA1263@kroah.com>
In-Reply-To: <20130624235003.GA1263@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 07:50 AM, Greg KH wrote:
> On Tue, Jun 25, 2013 at 09:40:51AM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> On Mon, 24 Jun 2013 15:40:35 -0700 Greg KH <greg@kroah.com> wrote:
>>> We are running out of time, my tree is pretty much closed for 3.11 now,
>>> should I just disable the build of this module for 3.11?
>> That's what I've been doing - it has never been enabled in a final
>> linux-next release.  So, it should probably just be disabled properly.
> I agree, now disabled.
>
> greg k-h
Greg,

Sorry for the delay. I've been caught up by other build failures that 
were found during my tests. I'm sending you the latest patches that 
should fix all the build errors. I've verified that we can now pass 
build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits. Please 
help to queue them.

I see that you have already disabled Lustre build. Can we re-enable it 
or do we have to wait until 3.10 is released?

Thanks,
Tao
