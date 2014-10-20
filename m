Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJTJml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:42:41 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:36232 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJTJmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:42:40 -0400
Message-ID: <1413798151.10246.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Date: Mon, 20 Oct 2014 11:42:31 +0200
In-Reply-To: <20141016154949.GR5930@redhat.com>
References: <20141016133658.GP5930@redhat.com> <20141016134430.GB7664@thin>
	 <20141016154949.GR5930@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 11:49 -0400, Aristeu Rozanski wrote:
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
> Cc: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

Yeah, looks sensible, and should work.

johannes

