Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaGISt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:49:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGISt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:49:56 -0400
Date: Wed, 9 Jul 2014 11:54:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171
 __ioremap_caller+0x290/0x2fa()
Message-ID: <20140709185421.GB20302@kroah.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
 <20140707204747.GA24934@kroah.com>
 <1502740.TF1NxA0qsa@calvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1502740.TF1NxA0qsa@calvin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 08:41:17PM +0200, Fabio Coatti wrote:
> In data lunedì 7 luglio 2014 13:47:47, Greg Kroah-Hartman ha scritto:
> > On Mon, Jul 07, 2014 at 10:32:56PM +0200, Fabio Coatti wrote:
> > > I'm seeing this message in latest kernels (this is from 3.15.4, but I have
> > > same
> > > message starting from 3.15.0, IIRC):
> > So 3.14.0 didn't show this?
> > 
> > If so, can you run 'git bisect' between those two kernel versions to try
> > to track down the issue?
> > 
> > thanks,
> > 
> > greg k-h
> ok, I tried to bisect as suggested and got the commit reported below. However 
> I'm not really sure to have got the right one, as one kernel refused to 
> compile during the last steps. However I post here the result, maybe they can 
> be useful.

Try cc:ing everyone on that patch, with the original information you
provided, and the linux-kernel mailing list.  Those developers should be
able to help you out properly.

thanks,

greg k-h
