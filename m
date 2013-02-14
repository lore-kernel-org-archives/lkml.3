Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab3BNO21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:28:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab3BNO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:28:25 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Pb9baIDBHs0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=yxsVMn-m8xMA:10 a=e5mUnYsNAAAA:8 a=Kfs0I6OjmMz0KnEfH7oA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360852104.23152.45.camel@gandalf.local.home>
Subject: Re: Including drm-intel tree to linux-next
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Feb 2013 09:28:24 -0500
In-Reply-To: <20130214141953.GA5746@pd.tnic>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
	 <20130214141953.GA5746@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 15:19 +0100, Borislav Petkov wrote:
> On Thu, Feb 14, 2013 at 03:12:02PM +0100, Daniel Vetter wrote:
> > Hi Steven,
> > 
> > Since about a year ago we've switched drm/i915 to buffer around 2
> > weeks worth of patches so that we can do decent QA before breaking
> > everyone's tree when things land in Dave's drm-next. But that also
> > means we'll miss out a bit in the integration testing -next provides,
> > which did hurt a bit in recent efforts. Hence can you please include
> > 
> > git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued
> > 
> > into linux-next? Probably best to merge it after drm-next. Note that
> > drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
> > mailing lists I'm supposed to follow? And if possible please cc
> > intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
> > with that tree pop up (you won't get moderation spam any more, we've
> > fixed that up).
> 
> I think you want to send this here to Stephen Rothwell. CCed.
> 

This is why I tell people to call me Steve or Steven, but never Stephen,
otherwise people might confuse me with one of the Stephens that also do
kernel development.

Note, this is not the first time I've been confused with someone else.
So don't feel bad ;-)

-- Steve


