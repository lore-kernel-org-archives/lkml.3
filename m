Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3FHBPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:15:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3FHBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:15:20 -0400
Date: Fri, 7 Jun 2013 18:15:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: shuox.liu@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl,
        len.brown@intel.com, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH 1/2] PM: use dpm_run_callback in device_prepare
Message-ID: <20130608011518.GA2819@kroah.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
 <1370593232-3602-2-git-send-email-shuox.liu@intel.com>
 <20130607173706.GA29615@kroah.com>
 <1370652235.4432.70.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370652235.4432.70.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 08:43:55AM +0800, Yanmin Zhang wrote:
> On Fri, 2013-06-07 at 10:37 -0700, Greg KH wrote:
> > On Fri, Jun 07, 2013 at 04:20:31PM +0800, shuox.liu@intel.com wrote:
> > > From: ShuoX Liu <shuox.liu@intel.com>
> > > 
> > > dpm_run_callback could show more debug info around prepare stage.
> > 
> > Why?  Who needs this?  What problem does it solve?
> > 
> > Without answers to this, why would you expect us to accept such a
> > change?
> It's to provide more debug info and developers can quickly find what
> prepare/complete callback consumes too much time.

What exact debug info is this providing, and why wouldn't you say all of
this in the original changelog information?

{hint}

