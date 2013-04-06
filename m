Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3DFF54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:57:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59058 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3DFF5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:57:55 -0400
Date: Fri, 5 Apr 2013 22:57:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Mirsal Ennaime <mirsal@mirsal.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
Message-ID: <20130406055751.GA11001@kroah.com>
References: <515E85C5.7010706@asianux.com>
 <20130405220156.GC31680@kroah.com>
 <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
 <515FAD37.4090300@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <515FAD37.4090300@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 01:05:59PM +0800, Chen Gang wrote:
> On 2013年04月06日 07:48, Arve Hjønnevåg wrote:
> > On Fri, Apr 5, 2013 at 3:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Fri, Apr 05, 2013 at 04:05:25PM +0800, Chen Gang wrote:
> >>> >>
> >>> >>   need break when 'target_thread' get value, firstly.
> >>> >>
> >>> >>     'tmp' is a stack (thread->transaction_stack),
> >>> >>     if 'proc' was the same between child node and parent node,
> >>> >>     the child would have higher priority than parent.
> >> >
> >> > Are you sure about this?
> >> >
> >> > have you tested it?
> >> >
> > Theoretically this should not change the behavior. The purpose of this
> > code it to make sure only thread per process is part of a transaction
> > stack, so if it finds more than one transaction with a matching
> > process, they should all point to the same thread object. I think a
> > better change description is needed though.
> 
> 
>   ok, thanks.
>   I will send patch v2 (also mark you as Signed-off).

You can NEVER add someone else's "Signed-off-by", unless they actually
do it (hint, that did not happen here at all.)

Please go read Documentation/SubmittingPatches again to learn exactly
what Signed-off-by: really is (a legal agreement), it is not something
to throw around lightly like this.

>     (if the patch v2 still need improvement, please reply in time).

In time for what?

Please test these patches before you resend them.

greg k-h
