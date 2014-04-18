Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaDRWwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:52:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaDRWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:52:20 -0400
Date: Fri, 18 Apr 2014 15:52:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] staging: gdm72xx: Minor cleanup
Message-ID: <20140418225229.GA28077@kroah.com>
References: <532BF9B0.2080008@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532BF9B0.2080008@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 04:34:56PM +0800, Michalis Pappas wrote:
> The following patches perform various cleanups on the gdm72xx driver.
> 
> PATCH 1/3 fixes some small coding style issues
> PATCH 2/3 removes an already completed item from the TODO list
> PATCH 3/3 replaces some jiffies comparisons with wrap-safe functions
> 
> After all patches have been applied, the only remaining issue on the
> TODO list is to conform to the coding standards. The remaining issues
> reported by checkpatch.pl are probably pedantic, so if agreed, that task
> can be removed from the list too.

These patches were all oddly corrupted, can you try resending them after
ensuring that you can still apply them on your end?

thanks,

greg k-h
