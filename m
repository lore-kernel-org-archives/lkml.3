Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3A3SgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:36:10 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:59588 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755307Ab3A3SgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:36:07 -0500
Message-ID: <1359570837.3325.30.camel@thor.lan>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 30 Jan 2013 13:33:57 -0500
In-Reply-To: <50FB0957.2000400@suse.cz>
References: <20130102153744.GC25940@redhat.com>
	 <20130118205358.GA6854@redhat.com> <20130118210728.GA16742@kroah.com>
	 <50FB0957.2000400@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-19 at 22:00 +0100, Jiri Slaby wrote:
> On 01/18/2013 10:07 PM, Greg Kroah-Hartman wrote:
> > Jiri, was there anything on the mailing list that I missed that should
> > have resolved this issue?  I thought it was being worked on, but I can't
> > seem to find any resolution at the moment.
> 
> Somebody had a patchset and promised to repost IIRC. I forgot his name
> though.
> 
> /me back from digging in the mail history.
> 
> Peter Hurley is the name.
> 
> Peter, what happened with your patches in the end, please?

The tty subsystem is very resilient to fixing :)

The thing I'm working on right now -- which hopefully is the last issue
with the line discipline logic -- occurs with parallel __tty_hangup()
and tty_release().

At the moment, I'm trying to narrow the conditions when this happens.

Regards,
Peter Hurley

