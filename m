Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3BYGVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 01:21:43 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:48644 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3BYGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:21:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
References: <20130225055218.GA1205@kroah.com>
	<CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
Date: Mon, 25 Feb 2013 16:21:40 +1000
Message-ID: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 4:06 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> Hi Ben,
>>
>> My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
>> down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
>> move link training helpers into core as display methods)
>>
>> Anything I can try to help solve this?
>>
>> Note, I'm using the Intel driver as the main controller for this laptop,
>> well, I think I am, my xorg log is attached.
>
> No you are using the nvidia, the efi always boots nvidia enabled now.
>
> Cool, might have to lend Ben my retina to see if he can reproduce.

btw I just tested my drm-next tree on mine and it resumed the display
fine, something oopsed a few seconds later that I haven't tracked down

git://git.freedesktop.org/~airlied/linux drm-next

I'll be sending it to Linus this evening or tomorrow morning, once I
fix my tree.

Dave.
