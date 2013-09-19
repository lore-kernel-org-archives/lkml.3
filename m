Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3ISCjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 22:39:00 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64095 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3ISCi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 22:38:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxJvJA6Y1ro2dZ+QQ-Rrrq6RCyz7GQShPxpucO8+1LVLQ@mail.gmail.com>
References: <CAPM=9twv-bb3MtnWNTT5+i5HfHQS+cbJG16xsaoL-XV_Qpf9Cw@mail.gmail.com>
	<CA+55aFxJvJA6Y1ro2dZ+QQ-Rrrq6RCyz7GQShPxpucO8+1LVLQ@mail.gmail.com>
Date: Thu, 19 Sep 2013 12:38:57 +1000
Message-ID: <CAPM=9txdQzoF0GirZhhBETFDtiPRDap20-OLH-Ab0AEVA7mEGw@mail.gmail.com>
Subject: Re: [git pull] drm radeon/nouveau/core fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Sep 18, 2013 at 9:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> mostly radeon fixes, with some nouveau bios parser, ttm fix and a fix
>> for AST driver.
>
> Ugh. I hope things calm down from here.

It shouldn't be that bad, this stuff was a bit delayed, some of it was
in my tree before the merge closed, I was just distracting myself with
other stuff,

The radeon stuff is for new hw that was merged in the merge window,
and more DPM fixes which is still off by default,

The only coming thing that worries me is the VGA arbitration fixes for
Intel GPUs is really screwed up and fixing it looks like resorting to
slightly drastic measures.

Dave.
