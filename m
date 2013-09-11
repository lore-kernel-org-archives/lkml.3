Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3IKSuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:50:07 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49017 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3IKSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:50:04 -0400
Date: Wed, 11 Sep 2013 21:48:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [117/251] radeon kms: do not flush uninitialized hotplug work
Message-ID: <20130911184839.GA2261@swordfish.minsk.epam.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042911.752089217@goodmis.org>
 <20130911090648.GA2271@swordfish.minsk.epam.com>
 <20130911083741.6b2783b2@gandalf.local.home>
 <20130911143629.GB2209@swordfish.minsk.epam.com>
 <20130911160016.GC24542@kroah.com>
 <20130911121318.31974aeb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911121318.31974aeb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/11/13 12:13), Steven Rostedt wrote:
> On Wed, 11 Sep 2013 09:00:16 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, Sep 11, 2013 at 05:36:29PM +0300, Sergey Senozhatsky wrote:
> > > This one on top of stable 3.6.11 git.
> > 
> > What do you mean by this?
> > 

I thought it was for linux-3.6.y stable branch. sorry, wrong
assumption.

> 
> It's for my stable branch. Although, 3.6.11.8 is a far cry from 3.6.11
> and the patch does not apply.
>

oh... so, we were not talking about linux-3.6.y branch from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git ?

a thousand apologies.

	-ss
