Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3FZN4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:56:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32898 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368Ab3FZN4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:56:54 -0400
Message-ID: <1372255013.2076.4.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Use normal Makefile, convert oz_trace
 to oz_dbg
From: Joe Perches <joe@perches.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: shigekatsu.tateno@atmel.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Date: Wed, 26 Jun 2013 06:56:53 -0700
In-Reply-To: <51CAD655.2070208@atmel.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
	 <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>
	 <20130625173840.GA8930@kroah.com> <1372208429.1245.94.camel@joe-AO722>
	 <51CAD655.2070208@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 12:53 +0100, Rupesh Gujare wrote:
> On 26/06/13 02:00, Joe Perches wrote:
> > Use a normal Makefile.
> > Convert oz_trace and oz_trace2 to a more normal oz_dbg.
> > Consolidate oztrace and ozconfig files to ozdbg.h
> > Update #include files.
> > Reflow modified lines, fit to 80 cols, align arguments.
> >
> > Add a couple more oz_<foo>_dbg macros to show how more
> > verbose device specific debugging could be added when a
> > struct device * or struct netdevice * is available.
> 
> Isn't this patch doing too many changes in single patch? Can we split 
> this patch into smaller patch series ?
> In addition to above, it also :-
> 1. Removes few unwanted logs.
> 2. Changes macro definition for oz_remember_urb() & oz_forget_urb() to 
> static inline function when WANT_URB_PARANOIA is not defined.

Yeah, sure, please do.
It was intended more to inform than be applied.
staging is closed for at least a few weeks.
Resubmit something like it in as many pieces
as you choose later.

> Above macros look good, however Greg have objection to define new macros 
> & he had suggested to use dev_dbg() & pr_debug().
> I will leave it to him, if he is all right to accept new macros for 
> debug logs.
> 
> Greg,
> Your comments please.


