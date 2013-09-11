Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3IKSyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:54:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3IKSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:54:51 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BNlKMqpuY8sA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=g-RjETWgj_YA:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=cY1P8z3Y1v6u_aVJI2AA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=SjKPycFA614A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 14:54:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [117/251] radeon kms: do not flush uninitialized hotplug work
Message-ID: <20130911145449.1679a883@gandalf.local.home>
In-Reply-To: <20130911184839.GA2261@swordfish.minsk.epam.com>
References: <20130911042707.738353451@goodmis.org>
	<20130911042911.752089217@goodmis.org>
	<20130911090648.GA2271@swordfish.minsk.epam.com>
	<20130911083741.6b2783b2@gandalf.local.home>
	<20130911143629.GB2209@swordfish.minsk.epam.com>
	<20130911160016.GC24542@kroah.com>
	<20130911121318.31974aeb@gandalf.local.home>
	<20130911184839.GA2261@swordfish.minsk.epam.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 21:48:39 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> On (09/11/13 12:13), Steven Rostedt wrote:
> > On Wed, 11 Sep 2013 09:00:16 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Wed, Sep 11, 2013 at 05:36:29PM +0300, Sergey Senozhatsky wrote:
> > > > This one on top of stable 3.6.11 git.
> > > 
> > > What do you mean by this?
> > > 
> 
> I thought it was for linux-3.6.y stable branch. sorry, wrong
> assumption.
> 
> > 
> > It's for my stable branch. Although, 3.6.11.8 is a far cry from 3.6.11
> > and the patch does not apply.
> >
> 
> oh... so, we were not talking about linux-3.6.y branch from
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git ?
> 
> a thousand apologies.
> 

Yeah, this is my extended stable, which is located in:

git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
v3.6-stable


I base the stable 3.6-rt patches off of this.

-- Steve
