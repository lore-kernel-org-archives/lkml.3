Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaJ0QWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:22:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44435 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaJ0QWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:22:23 -0400
Date: Mon, 27 Oct 2014 16:22:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141027162220.GV7996@ZenIV.linux.org.uk>
References: <1413881397.30379.7.camel@hadess.net>
 <5446B3CC.1080904@amacapital.net>
 <1414418126.30379.47.camel@hadess.net>
 <CALCETrWQ5r39aqP+MFZuD__5HiNAc+cDQoghsDSEc9oVsmsyvQ@mail.gmail.com>
 <1414424723.30379.59.camel@hadess.net>
 <CALCETrVYK=GBHbcoJr-zz4tUWv7sdxb-6v7TuuOgcHPCq7s9Pg@mail.gmail.com>
 <1414426146.30379.62.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414426146.30379.62.camel@hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:09:06PM +0100, Bastien Nocera wrote:

> > > By having a well-known protocol and defined semantics on top of that
> > > communication channel. I could try and re-explain why kdbus is needed,
> > > but I wouldn't do as good a job as the people working on it, so best to
> > > refer to the individual threads about kdbus on this list.
> > >
> > 
> > I didn't do a good job asking the question, then.
> > 
> > What's wrong with fds in the context of communicating with a
> > container?  What does kdbus do container-wise that helps?
> 
> Nothing's wrong with using fd's. They're just a very poor API.

For a proof by assertion it's too transparent, for any other kind of
explanation - far too short on details...
