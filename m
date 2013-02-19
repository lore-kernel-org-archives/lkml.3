Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3BSK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:28:20 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:64700 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3BSK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:28:18 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130219130149.a3762b8a2f38879d3e0e6243@canb.auug.org.au>
References: <20130215133714.6f55139ad1a037b7b9fa1b70@canb.auug.org.au>
	<CAKMK7uGG4R68ED4M1uYRUZAhxRMzao0vk9oFg_vxZ8ofhx1=yw@mail.gmail.com>
	<20130215081626.6cbb2e74@jbarnes-desktop>
	<20130219130149.a3762b8a2f38879d3e0e6243@canb.auug.org.au>
Date: Tue, 19 Feb 2013 11:28:17 +0100
Message-ID: <CAKMK7uEYv+u0DxgbpbTg4ySK+9+PmYu-5MfFTid-PARHd_PcjQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm-intel tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 3:01 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 15 Feb 2013 08:16:26 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> On Fri, 15 Feb 2013 10:30:16 +0100
>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>
>> > On Fri, Feb 15, 2013 at 3:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > >
>> > > After merging the drm-intel tree, today's linux-next build (x86_64
>> > > allmodconfig) failed like this:
>> > >
>> > > ERROR: "pm_vt_switch_unregister" [drivers/video/fb.ko] undefined!
>> > >
>> > > I have dropped the tree for today.
>> >
>> > Meh, that fail was already reported from Wu's kernel builder a few
>> > days ago, but no patch yet showed up to fix things. Since the i915
>> > side of that work isn't ready yet either I've dropped the offending
>> > patches.
>>
>> I sent a patch yesterday for this.  I'll bounce it over again.
>
> I am still getting that build failure.

Ok, should be really fixed now, my apologies for the mess.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
