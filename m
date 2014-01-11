Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbaAKATY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:19:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAKATV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:19:21 -0500
Date: Fri, 10 Jan 2014 16:19:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v3 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140111001953.GA25593@kroah.com>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
 <20140110150856.GB22533@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110150856.GB22533@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 07:08:56AM -0800, Greg KH wrote:
> On Fri, Jan 10, 2014 at 08:57:17AM -0500, Tejun Heo wrote:
> > Hello,
> > 
> > This is v3 of kernfs self-removal patchset.  v2 posting mistakenly
> > sent out slightly old set of patches, so the v3.  Sorry about the
> > noise.  Changes from the first take[L] are,
> 
> It's really late in the -rc cycle for me to take this for 3.14, but I
> see patch 1 is a good one to have, so I'll take that now, and queue the
> rest up for after 3.14-rc1 is out for 3.15.  Is that ok with you, or do
> you have patches that depend on this series for 3.14?

Oh nevermind, these are all good, now applied :)

greg k-h
