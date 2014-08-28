Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaH1TSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:18:20 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48446 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH1TSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140828153252.GA18868@kroah.com>
References: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com>
	<20140828152205.GA18432@kroah.com>
	<CAG-aW05qkQKgntBM87XHSMECjD-GMjeRt+m0-0CkezBG_weCOg@mail.gmail.com>
	<20140828153252.GA18868@kroah.com>
Date: Thu, 28 Aug 2014 21:18:17 +0200
Message-ID: <CAG-aW07Lx=WOEf+j=_+G5T57uzhvKiP3-ZpaadKvoafW=iJKrw@mail.gmail.com>
Subject: Re: linux-3.16.2 queue (3.16.1+)
From: Matt <jackdachef@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 5:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Aug 28, 2014 at 05:27:27PM +0200, Matt wrote:
>> On Thu, Aug 28, 2014 at 5:22 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Aug 28, 2014 at 05:16:58PM +0200, Matt wrote:
>> >> Hi Greg,
>> >>
>> >>
>> >> please consider adding the following 2 patches to 3.16.2:
>> >>
>> >> Jan Kara (1):
>> >>       reiserfs: Fix use after free in journal teardown
>> >>
>> >> Jeff Mahoney (1):
>> >>       reiserfs: fix corruption introduced by balance_leaf refactor
>> >>
>> >>
>> >>
>> >> Reason/Related:
>> >>
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=83121
>> >>
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=83321
>> >>
>> >> http://forums.gentoo.org/viewtopic-t-998538-postdays-0-postorder-asc-start-0.html
>> >>
>> >>
>> >> Many thanks in advance
>> >
>> > I need git commit ids of these patches in Linus's tree, can you provide
>> > those please?
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>>
>> Sure:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
>> reiserfs: fix corruption introduced by balance_leaf refactor
>>
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=01777836c87081e4f68c4a43c9abe6114805f91e
>> reiserfs: Fix use after free in journal teardown
>>
>>
>>
>> are checkpatch warnings usually also fixed within stable releases ?
>
> No, not at all, please read Documentation/stable_kernel_patches.txt for
> what is acceptable for stable kernel patches.
>
> thanks,
>
> greg k-h


okay, will do

thanks for pointing that out


Regards

Matt
