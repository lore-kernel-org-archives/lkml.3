Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKJDtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:49:08 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33728 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbaKJDtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:49:05 -0500
X-Sasl-enc: 9tbGJZxAhZ6GggHXbo7MWhQmQxDWWfyK3IV32yC/kMc9 1415591343
Date: Mon, 10 Nov 2014 11:56:36 +0900
From: Greg KH <greg@kroah.com>
To: Peter Weber <peter.weber@ttyhoney.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [drm/i915: Do not store the error pointer for a failed userptr
 registration] Candidate for stable tree?
Message-ID: <20141110025636.GA29809@kroah.com>
References: <574931b8edea4d60014d5e9b31daa4a1@ttyhoney.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <574931b8edea4d60014d5e9b31daa4a1@ttyhoney.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:41:02PM +0100, Peter Weber wrote:
> Hello!
> 
> Is the patch[0] mentioned in the subject a possible candidate for the next
> release of the stable kernel, at time of writing "3.17.3"? It looks like,
> this is
> causing serious problems and we are currently discussing this on the
> bugtracker of
> Archlinux[1].
> 
> I'm not sure if I'm personally affected. I suffered unexpected freezes
> since 3.17-rc4 on my machine, at least STDIO and STDOUT are frozen. Maybe
> the
> reaction differs based on the kernel options (see changed behaviour
> through
> CONFIG_PREEMPT_VOLUNTARY=y). In my case, I don't see a null pointer in my
> log
> files.
> 
> I hope this doesn't offend against the stable kernel rules.
> 
> [0]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e9681366ea9e76ab8f75e84351f2f3ca63ee542c
> # commit id is: e9681366ea9e76ab8f75e84351f2f3ca63ee542c
> # already send to stable@vger.kernel.org, but not included in current
> stable "3.17.2"
> [1] https://bugs.archlinux.org/task/42353

It's now queued up, sorry, the backlog is really long right now :(
