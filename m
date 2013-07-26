Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3GZIus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:50:48 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:50698 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753446Ab3GZIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:50:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 26 Jul 2013 09:50:35 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130726085035.GJ13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <20130725192248.GA13295@cantiga.alporthouse.com>
 <CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
 <CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
 <20130725215259.GB13295@cantiga.alporthouse.com>
 <CA+icZUXZKndg7==Y6v2Z45WZDp+tDC5FzaOC=KWTf4m=rjUKnA@mail.gmail.com>
 <20130725232556.GF13295@cantiga.alporthouse.com>
 <CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
 <20130726072646.GH13295@cantiga.alporthouse.com>
 <CA+icZUXuj1O3oUvr_43BZDD_ikWyY9GxfOdzb3GLWJ1X1hvxyQ@mail.gmail.com>
 <CA+icZUWJynMr-OvXwN+2eRxWWOpt2s1-Q5UMrRt3rXDcCJpwkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWJynMr-OvXwN+2eRxWWOpt2s1-Q5UMrRt3rXDcCJpwkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:27:03AM +0200, Sedat Dilek wrote:
> On Fri, Jul 26, 2013 at 10:25 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > ...
> > ... but does not start as well, so it seems to be a kernel-issue as
> > assumed (2nd confirmation).
> >
> > X.log attached.
> >
> 
> Now, really w/ promised attachment.

Yes, same failure (GTT mmaps) but at a later point, and UXA has no
fallback plan.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
