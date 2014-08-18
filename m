Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaHRPH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaHRPH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:07:57 -0400
Date: Mon, 18 Aug 2014 11:07:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818150752.GS49576@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
 <20140818091239.GD25495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818091239.GD25495@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:12:39AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > From: Ulrich Obergfell <uobergfe@redhat.com>
> > 
> > In some cases we don't want hard lockup detection enabled by default.
> > An example is when running as a guest. Introduce
> > 
> >   watchdog_enable_hardlockup_detector(bool)
> 
> So, the name watchdog_enable_hardlockup_detector_enable(false) 
> is both too long and also really confusing (because first it 
> suggests enablement, then disables it), so I renamed it to 
> hardlockup_detector_set(), which allows two natural variants:
> 
> 	hardlockup_detector_set(false);
> 	...
> 	hardlockup_detector_set(true);

Fair enough.  Thanks!

Cheers,
Don
