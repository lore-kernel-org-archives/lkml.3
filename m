Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHRIqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:46:07 -0400
Received: from mo-online.de ([89.238.66.174]:45399 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaHRIqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:46:05 -0400
Date: Mon, 18 Aug 2014 10:46:00 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [TYPO 9/9] [typo] spelling, punctuation in Documentation/...
Message-ID: <20140818084600.GA13463@mo-online.de>
References: <20140817183058.GJ4077@mo-online.de>
 <53F1AD31.3030109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53F1AD31.3030109@infradead.org>
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Randy,

thanks for you reply.

* Randy Dunlap <rdunlap@infradead.org> [140818 09:37]:
> On 08/17/14 11:30, Markus Osterhoff wrote:
> > diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> > -gcc`) for some information on them.
> > +gcc') for some information on them.
> Backquotes imply that the contents (string) can be entered at a shell prompt;
> i.e., they are a command.
Ah, I see.

> > -It is worth mentioning what Andrew Morton wrote on the linux-kernel
> > +It is worth mentioning what Andrew Morton wrote on the Linux-kernel
> The mailing list is "linux-kernel".
Stupid me, sorry :)

> > diff --git a/Documentation/ManagementStyle b/Documentation/ManagementStyle
> > -Btw, when talking about "kernel manager", it's all about the technical
> > +Btw., when talking about "kernel manager", it's all about the technical
> BTW (or Btw) is common -- no period.
Okay.

> > diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> > index 0a523c9..a358031 100644
> > --- a/Documentation/SubmittingPatches
> > +++ b/Documentation/SubmittingPatches
> > @@ -227,8 +227,8 @@ Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
> >  He gets a lot of e-mail, so typically you should do your best to -avoid-
> >  sending him e-mail. 
> >  
> > -Patches which are bug fixes, are "obvious" changes, or similarly
> > -require little discussion should be sent or CC'd to Linus.  Patches
> > +Patches, which are bug fixes, are "obvious" changes, or similarly
> 
>    Patches which are bug fixes or "obvious" changes or similarly
> 
> > +require little discussion, should be sent or CC'd to Linus.  Patches
>   why the added comma?
My feeling is this increases the comprehensibility.

> >  which require discussion or do not have a clear advantage should
> >  usually be sent first to linux-kernel.  Only after the patch is
> >  discussed should the patch then be submitted to Linus.
Greetings,
Markus

