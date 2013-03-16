Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3CPQPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:15:36 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44899 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CPQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:15:34 -0400
Date: Sat, 16 Mar 2013 09:16:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 00/50] staging: omap-thermal: several code refactoring
Message-ID: <20130316161641.GA2630@kroah.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <20130316090540.GQ9138@mwanda>
 <5144698B.9080703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5144698B.9080703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 08:46:03AM -0400, Eduardo Valentin wrote:
> Hello Dan,
> 
> On 16-03-2013 05:05, Dan Carpenter wrote:
> >I've reviewed this set.
> >
> >I hate to make people redo whole patchset sets, and I hate
> >re-reviewing code.  Obviously, I don't really like the bunny hop
> >patches and I'm trying to discourage that going forward.  ;P  But
> >I wouldn't say it's a "Redo the whole thing" kind of problem.
> >
> >Could just resend patch 33 and 47?  You should probably be able to
> >redo those without changing the rest.
> 
> I could of course change them if the comment is better clarified. As
> I mentioned as reply to one of your comments, those changes are
> following what is suggested in CodingStyle file.
> 
> I can of course send a diff on top of 33, to fix the introduce bug.
> 
> For 47, I'm not sure the comment is fully applicable.

As I've taken all of these already (sorry Dan, I was fast and I didn't
review them as well as you did), you will have to just send incremental
patches on top of the whole series in order for me to be able to apply
them.

thanks,

greg k-h
