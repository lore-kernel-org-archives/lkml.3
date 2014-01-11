Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaAKSpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:45:21 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37625 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaAKSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:45:17 -0500
Date: Sat, 11 Jan 2014 13:45:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v3 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140111184513.GA3257@mtj.dyndns.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
 <20140110150856.GB22533@kroah.com>
 <20140111001953.GA25593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111001953.GA25593@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Greg.

On Fri, Jan 10, 2014 at 04:19:53PM -0800, Greg KH wrote:
> > It's really late in the -rc cycle for me to take this for 3.14, but I
> > see patch 1 is a good one to have, so I'll take that now, and queue the
> > rest up for after 3.14-rc1 is out for 3.15.  Is that ok with you, or do
> > you have patches that depend on this series for 3.14?
> 
> Oh nevermind, these are all good, now applied :)

I don't have anything depending on the series for the up coming merge
window so 3.15 merge window would have been fine but 3.14 merge
windows wokrs too. :)

Thanks.

-- 
tejun
