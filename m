Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3JCTfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:35:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:41797 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab3JCTfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:35:08 -0400
Date: Thu, 3 Oct 2013 15:34:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nikita Danilov <nikita@clusterfs.com>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131003193442.GB8000@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Peng Tao <tao.peng@emc.com>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Nikita Danilov <nikita@clusterfs.com>
References: <20131003163908.GD31721@thunk.org>
 <20131003172621.GA14775@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003172621.GA14775@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:26:21AM -0700, Greg KH wrote:
> > Does this sound reasonable?
> 
> Sounds reasonable to me, care to send a patch to do so?
> 

I can do that, but I was waiting for Andras, Peng or Nikita to let me
now if there was something I was missing or not.  I'm pretty sure it's
something bogus, perhaps left over from a OS abstraction layer to
support Solaris or some such, but I am curious what was the historical
reason for the current code.

Cheers,

						- Ted
