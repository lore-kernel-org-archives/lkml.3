Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaJPDwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:52:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35260 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaJPDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:52:06 -0400
X-Originating-IP: 212.144.255.202
Date: Thu, 16 Oct 2014 05:51:58 +0200
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
Message-ID: <20141016035157.GA25133@thin>
References: <20141015152522.GL5930@redhat.com>
 <20141015231446.GD685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015231446.GD685@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 01:14:46AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Oct 15, 2014 at 11:25:23AM -0400, Aristeu Rozanski wrote:
> > It's desirable for allnconfig and tinyconfig targets to result in the
> > least amount of code possible. DISABLE_DEV_COREDUMP exists as a way to
> > switch off DEV_COREDUMP regardless if any drivers select
> > WANT_DEV_COREDUMP.
> > 
> > This patch renames the option to ENABLE_DEV_COREDUMP and setting it to
> > 'n' (as in allnconfig or tinyconfig) will effectively disable device
> > coredump.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
> 
> Any reason you didn't cc: the author of this feature / Kconfig option
> about this change you are proposing?

Likely my fault; I'd suggested using get_maintainer.pl, which does not
show that for this patch:

~/src/linux$ scripts/get_maintainer.pl < /tmp/patch
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:DRIVER CORE, KOBJ...)
linux-kernel@vger.kernel.org (open list)
