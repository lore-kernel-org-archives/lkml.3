Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaADUXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:23:36 -0500
Received: from mail.wdtv.com ([66.118.69.84]:51515 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbaADUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:23:35 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Linux 3.2.54
Date: Sat, 4 Jan 2014 15:23:32 -0500
Cc: Teck Choon Giam <giamteckchoon@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
References: <1388755289.22017.42.camel@deadeye.wl.decadent.org.uk> <CAEwRVpN7z5rDnqNg3ZF+5=Go1EXKAm0TutQPUZ_mj2OCQ5-kwQ@mail.gmail.com> <20140104173210.GA32402@kroah.com>
In-Reply-To: <20140104173210.GA32402@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201401041523.33303.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 January 2014, Greg KH wrote:
>On Sun, Jan 05, 2014 at 12:43:05AM +0800, Teck Choon Giam wrote:
>> Hi Ben,
>> 
>> On Fri, Jan 3, 2014 at 9:21 PM, Ben Hutchings <ben@decadent.org.uk> 
wrote:
>> > I'm announcing the release of the 3.2.54 kernel.
>> > 
>> > All users of the 3.2 kernel series should upgrade.
>> > 
>> > The updated 3.2.y git tree can be found at:
>> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st
>> >         able.git linux-3.2.y
>> > 
>> > and can be browsed at the normal kernel.org git web browser:
>> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable
>> >         .git
>> 
>> Just for your information,
>> https://www.kernel.org/pub/linux/kernel/v3.x/ I can only see version
>> 3.2.54 with tar.xz and tar.gz where tar.bz2 extension is missing.  I
>> don't know whether is this intentionally but just to let you know in
>> case.
>
>As was announced earlier, there will not be any more .bz2 tarballs
>created starting this year, sorry.  So this was intentional.
>
>thanks,
>
>greg k-h

And good riddance.  bz2's have made enough unpacking mistakes that I 
haven't pulled one in years unless it was the only choice.

Cheers, Gene
