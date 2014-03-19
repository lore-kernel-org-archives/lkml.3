Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbaCSHUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:20:09 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:51522 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbaCSHUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:20:07 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140319015415.GD7956@bwidawsk.net>
References: <20140319115350.7860f102a804a9975ba6e93d@canb.auug.org.au>
	<20140318211842.017be730@gandalf.local.home>
	<20140319015415.GD7956@bwidawsk.net>
Date: Wed, 19 Mar 2014 08:20:06 +0100
Message-ID: <CAKMK7uFEBe6RwgHBzJ7zwzqhTg1s+mxFKcfVxo6oychvZzZeFw@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: build failure after merge of the
 drm-intel tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Ben Widawsky <ben@bwidawsk.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 2:54 AM, Ben Widawsky <ben@bwidawsk.net> wrote:
> On Tue, Mar 18, 2014 at 09:18:42PM -0400, Steven Rostedt wrote:
>> On Wed, 19 Mar 2014 11:53:50 +1100
>> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>>
>> > Caused by commit a25ca17c1eac ("drm/i915: Do not dereference pointers
>> > from ring buffer in evict event").
>> >
>> > I have used the drm-intel tree from next-20140318 for today.
>> >
>>
>> Bah! I'm still suffering from jet lag (just came back from Linux-Tage
>> in Chemnitz).
>>
>> The next time I compile test a patch for a module, I'll make sure I have
>> that module's config option set :-(  The woe of using localmodconfig. I
>> should have picked the box with the i915. :-/
>>
>> Below is the fix. I'll repost a v2 of the original patch.
>>
>> Sorry about that.
>>
>
> I was about to send out the same fix when I saw this.
>
> Reviewed-by: Ben Widawsky <ben@bwidawsk.net>

Just fixed this this morning before starting to read mail - my
apologies the mess me pushing out a patch yesterday right before
rushing out caused, really shouldn't be doing that ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
