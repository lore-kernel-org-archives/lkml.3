Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3AXSbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:31:13 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57522 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3AXSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:31:11 -0500
Date: Thu, 24 Jan 2013 10:31:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: module: put modules in list much earlier.
Message-ID: <20130124183109.GG12106@kroah.com>
References: <20130121014613.CF6ED660735@gitolite.kernel.org>
 <20130121201221.GA8149@kroah.com>
 <87mww2uqpy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mww2uqpy.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 08:46:25AM +1030, Rusty Russell wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> > Rusty, should the commit below be applied to the 3.7-stable kernel tree?
> >
> > thanks,
> >
> > greg k-h
> 
> Good point. looks like commit which caused this (e9bda3b) went in 3.6
> so I think you'll want the following:
> 
> 0d21b0e3477395e7ff2acc269f15df6e6a8d356d module: add new state MODULE_STATE_UNFORMED
> 1fb9341ac34825aa40354e74d9a2c69df7d2c304 module: put modules in list much earlier.
> ee61abb3223e28a1a14a8429c0319755d20d3e40 module: fix missing module_mutex unlock

Thanks, the second one required a bit of tweaking by hand, but it looks
good now, all applied.

greg k-h
