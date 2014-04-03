Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaDCWGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:06:32 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:38885 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaDCWG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:06:28 -0400
X-AuditID: cbfec373-b7f4a6d000005e0a-c3-533ddb620b46
Date: Thu, 03 Apr 2014 19:06:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        james.hogan@imgtec.com
Subject: Re: [GIT PULL for v3.15-rc1] media updates
Message-id: <20140403190619.4878ddb4@samsung.com>
In-reply-to: <20140403214656.GA4662@hardeman.nu>
References: <20140403131143.69f324c7@samsung.com>
 <20140403214656.GA4662@hardeman.nu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/hEN2k27bBBjv3a1nMWb+GzeLikXXs
	Fu/mvWC2uLxrDptFz4atrBaP+t6yO7B5nLjfxezRs/MMo8eJGb9ZPD5vkgtgieKySUnNySxL
	LdK3S+DKeL7yH3vBUY6KOUvOsjUwPmLrYuTkkBAwkTi1aBE7hC0mceHeeqA4F4eQwBJGiRk3
	drNDON1MErcfHWQEqWIRUJU48XQ+WAebgJHEq8YWVhBbRMBM4sKJHYwgDcwC7xkllsz+AVYk
	LGAs8flVH5jNK2Ao8aerHWwQp4CBxNVNf8GahQTCJa62b4I6w0ni1evJTBD1ghI/Jt9jAbGZ
	BdQlJs1bxAxha0s8eXeBdQKjwCwkZbOQlM1CUraAkXkVo2hpcXJBcVJ6rpFecWJucWleul5y
	fu4mRkhQF+9gfLHB6hCjAAejEg8vR7ptsBBrYllxZe4hRgkOZiUR3tY2oBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbGuD75z2f2iNvcffNt5vMp2qFxOe9m+65vvVuys+Vd+Q+ODaebZ5tFT5h6
	9P39b6eddvO8jn/+fT9DgPFip3vqi28FaG/aw1xSkya87KTEnDf9Ne+bRb6X9nAfUXsm+jJu
	n0TP77L76mc+bUuTuiI14bye6ts2w19pV7omaJaF6AmUrvxmff5GvxJLcUaioRZzUXEiAAki
	t6pIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 03 Apr 2014 23:46:56 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Thu, Apr 03, 2014 at 01:11:43PM -0300, Mauro Carvalho Chehab wrote:
> >Hi Linus,
> >
> >Please pull from:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> >
> ...
> >James Hogan (27):
> ...
> >      [media] media: rc: add sysfs scancode filtering interface
> >      [media] media: rc: change 32bit NEC scancode format
> ...
> >      [media] rc-main: add generic scancode filtering
> 
> Umm...we (mostly James and I, but you as well) have been discussing on
> the linux-media whether those patches shouldn't be reverted...this pull
> request seems to have overlooked that discussion...or have I missed
> something?

The discussions didn't finish yet. We can't hold pushing the patches
forever due to a few patches in this series, and there's another pull
request waiting for this to be merged.

We can latter send a fix for the patches that are not ok early at
-rc tests, or next week if we come on an agreement.

Regards,
Mauro
