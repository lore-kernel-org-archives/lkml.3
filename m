Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaAMWyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:54:39 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:58967 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaAMWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:54:35 -0500
Date: Mon, 13 Jan 2014 17:54:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v3 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140113225430.GB10124@mtj.dyndns.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
 <20140110150856.GB22533@kroah.com>
 <20140111001953.GA25593@kroah.com>
 <20140111184513.GA3257@mtj.dyndns.org>
 <20140113211715.GB3480@mtj.dyndns.org>
 <20140113225034.GA4031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113225034.GA4031@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Mon, Jan 13, 2014 at 02:50:34PM -0800, Greg KH wrote:
> No worries, but it is sad, I really liked seeing that odd "remove self"
> function go away.  I've now reverted all 15 patches, please verify that

Oh, I'll repost it and it's probably gonna be about the same as my
initial posting which was simpler and actually reduced LOC.  I just
wanna make sure cgroup conversion works fully before reposting it.  I
think it should but I've been wrong a couple times already, so...

> I didn't mess anything up in my tree somehow.

diff'ed before & after and the only difference is the new component
thing, so it looks all good to me.

Thanks.

-- 
tejun
