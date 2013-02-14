Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab3BNPdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:33:45 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37103 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760579Ab3BNPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:33:44 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1360852104.23152.45.camel@gandalf.local.home>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
	<20130214141953.GA5746@pd.tnic>
	<1360852104.23152.45.camel@gandalf.local.home>
Date: Thu, 14 Feb 2013 16:33:42 +0100
Message-ID: <CAKMK7uGoX9yjPE9wXVNtypbvfZoHHMQKJb=-xW35ec_-AcM_pQ@mail.gmail.com>
Subject: Re: Including drm-intel tree to linux-next
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 3:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2013-02-14 at 15:19 +0100, Borislav Petkov wrote:
>> On Thu, Feb 14, 2013 at 03:12:02PM +0100, Daniel Vetter wrote:
>> > Hi Steven,
>> >
>> > Since about a year ago we've switched drm/i915 to buffer around 2
>> > weeks worth of patches so that we can do decent QA before breaking
>> > everyone's tree when things land in Dave's drm-next. But that also
>> > means we'll miss out a bit in the integration testing -next provides,
>> > which did hurt a bit in recent efforts. Hence can you please include
>> >
>> > git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued
>> >
>> > into linux-next? Probably best to merge it after drm-next. Note that
>> > drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
>> > mailing lists I'm supposed to follow? And if possible please cc
>> > intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
>> > with that tree pop up (you won't get moderation spam any more, we've
>> > fixed that up).
>>
>> I think you want to send this here to Stephen Rothwell. CCed.
>>
>
> This is why I tell people to call me Steve or Steven, but never Stephen,
> otherwise people might confuse me with one of the Stephens that also do
> kernel development.
>
> Note, this is not the first time I've been confused with someone else.
> So don't feel bad ;-)

Oops, indeed picked the wrong mail from my sea of "drm/i915 broke
stuff, again" mails ;-) Sorry for the noise, Steve.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
