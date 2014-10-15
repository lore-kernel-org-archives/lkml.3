Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaJOXPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaJOXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:15:50 -0400
Date: Thu, 16 Oct 2014 01:14:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
Message-ID: <20141015231446.GD685@kroah.com>
References: <20141015152522.GL5930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015152522.GL5930@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 11:25:23AM -0400, Aristeu Rozanski wrote:
> It's desirable for allnconfig and tinyconfig targets to result in the
> least amount of code possible. DISABLE_DEV_COREDUMP exists as a way to
> switch off DEV_COREDUMP regardless if any drivers select
> WANT_DEV_COREDUMP.
> 
> This patch renames the option to ENABLE_DEV_COREDUMP and setting it to
> 'n' (as in allnconfig or tinyconfig) will effectively disable device
> coredump.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

Any reason you didn't cc: the author of this feature / Kconfig option
about this change you are proposing?

Please resend it with the maintainer of this code in the distribution
list.

greg k-h
