Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287Ab3BTMtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:49:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40239 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934388Ab3BTMtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:49:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] lockdep: check that no locks held at freeze time
Date: Wed, 20 Feb 2013 13:55:49 +0100
Message-ID: <7488660.sdbECaVo1t@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130220103719.GA7691@gmail.com>
References: <20130216170605.GC4910@redhat.com> <1361325468-7998-1-git-send-email-msb@chromium.org> <20130220103719.GA7691@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 11:37:19 AM Ingo Molnar wrote:
> 
> * Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > We shouldn't try_to_freeze if locks are held. Verified that
> > I get no lockdep warnings after applying this patch and
> > "vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".
> > 
> > Changes since v1:
> > * LKML: <20130215111635.GA26955@gmail.com> Ingo Molnar
> >   * Added a msg string that gets passed in.
> > * LKML: <20130215154449.GD30829@redhat.com> Oleg Nesterov
> >   * Check PF_NOFREEZE in try_to_freeze().
> > Changes since v2:
> > * LKML: <20130216170605.GC4910@redhat.com> Oleg Nesterov
> >   * Avoid unnecessary PF_NOFREEZE check when !CONFIG_LOCKDEP.
> > * Mandeep Singh Baines
> >   * Generalize an exit specific printk.
> > 
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: Tejun Heo <tj@kernel.org>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Rafael J. Wysocki <rjw@sisk.pl>
> > CC: Ingo Molnar <mingo@redhat.com>
> 
> Looks good to me now.
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Which tree should this go through?

Well, I can take it if that's OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
