Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaHRTAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:00:49 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45350 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaHRTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:00:47 -0400
Date: Mon, 18 Aug 2014 21:00:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818190042.GA5074@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
 <20140818091644.GE25495@gmail.com>
 <20140818151737.GT49576@redhat.com>
 <20140818180735.GB4540@gmail.com>
 <20140818185332.GC49576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818185332.GC49576@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Don Zickus <dzickus@redhat.com> wrote:

> > 2)
> > 
> > The softlockup and hardlockup detection control variables 
> > should be in separate flags, inside and outside the kernel 
> > - they (should) not relate to each other.
> 
> They did because years ago I thought we wanted to keep them 
> as one entity instead of two.  I would have to re-work the 
> code to do this (and add more knobs).
> 
> I presume you would want those changes done before taking 
> this patchset?

Yeah, fixing/cleaning up things would be nice before spreading 
the pain via new features/control mechanisms.

Thanks,

	Ingo
