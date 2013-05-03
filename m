Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269Ab3ECLf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:35:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56368 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763228Ab3ECLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:35:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arve@android.com
Subject: Re: [PATCH v2 00/10] optimize freezing tasks by reducing task wakeups
Date: Fri, 03 May 2013 13:43:46 +0200
Message-ID: <6539209.phsENQLmv5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130503001026.GZ19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com> <1678114.cijx7evM08@vostro.rjw.lan> <20130503001026.GZ19814@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 02, 2013 05:10:26 PM Tejun Heo wrote:
> Hey, Rafael.
> 
> On Thu, May 02, 2013 at 11:06:35PM +0200, Rafael J. Wysocki wrote:
> > > v2 moves the skip check to freeze_task(), and expands the commit
> > > messages.
> > 
> > The entire series makes sense to me, so are there any objections?
> > 
> > Tejun, Oleg??
> 
> Generally looks good to me.  I'm a bit uncomfortable with the
> generic-looking expansion of the freezable API as it can't be
> something which can be used in any generic manner.  It'd be great if
> we just add only the used ones (do we already?)

I'm not sure about that, unfortunately.

> and add some sort of lockdep annotation so that people don't use them while
> holding any locks.

I guess we can add that anyway?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
