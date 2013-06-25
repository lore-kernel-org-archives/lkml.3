Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3FYSDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:03:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49839 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971Ab3FYSDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:03:10 -0400
Message-ID: <1372183389.1245.74.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>, Jason Baron <jbaron@akamai.com>
Cc: shigekatsu.tateno@atmel.com, devel@linuxdriverproject.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 11:03:09 -0700
In-Reply-To: <1372183005.1245.72.camel@joe-AO722>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
	 <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>
	 <20130625173840.GA8930@kroah.com> <1372183005.1245.72.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Using Jason Baron's most current email address)

On Tue, 2013-06-25 at 10:56 -0700, Joe Perches wrote:
> On Tue, 2013-06-25 at 10:38 -0700, Greg KH wrote:
> > On Tue, Jun 25, 2013 at 10:29:50AM -0700, Joe Perches wrote:
> > > a long needed extension to dev_dbg is to enable classes
> > > of messages by level or mask.
> > > 
> > > There are many existing macros like
> > > 
> > > #define module_dbg(level, fmt, ...)
> > > do {
> > > 	if (level >= some_module_var)
> > > 		debug_something(...);
> > > } while (0)
> > > 
> > > and
> > > 
> > > #define module_dbg(mask, fmt, ...)
> > > do {
> > > 	if (mask & some_module_var)
> > > 		debug_something(...)
> > > } while (0)
> > > 
> > > It'd be nice to consolidate those in dev_dbg
> > 
> > I'd almost recommend that all of them just be removed, because most of
> > them were only used for debugging the code the first time it was
> > developed, right?  Only for very limited usages would this type of thing
> > be needed.
> 
> Maybe, though that's hard to know with certainty.
> How often module options are used isn't easy to find out.
> 
> These forms are sometimes used to reduce object size.

Hey Jason.  Your redhat.com address is out of date.

If you're still interested in dynamic_debug, you should
update your MAINTAINERS entry.


