Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaKBBaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:30:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKBBaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:30:35 -0400
Date: Sat, 1 Nov 2014 18:29:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kdbus: add documentation
Message-ID: <20141102012923.GA9717@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-2-git-send-email-gregkh@linuxfoundation.org>
 <alpine.DEB.2.02.1410301231040.32212@pmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410301231040.32212@pmeerw.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 01:20:23PM +0100, Peter Meerwald wrote:
> 
> > kdbus is a system for low-latency, low-overhead, easy to use
> > interprocess communication (IPC).
> > 
> > The interface to all functions in this driver is implemented through ioctls
> > on /dev nodes.  This patch adds detailed documentation about the kernel
> > level API design.
> 
> just some typos below

<snip>

Many thanks for the fixes, I've made them all to the file now, it will
show up in the next version we send out.

greg k-h
