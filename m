Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3BZIqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:46:13 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:59632 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678Ab3BZIqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:46:11 -0500
Date: Tue, 26 Feb 2013 12:46:06 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] proc connector: reject unprivileged listener bumps
Message-ID: <20130226084606.GA21048@ioremap.net>
References: <20130226073225.GA15489@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226073225.GA15489@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 25, 2013 at 11:32:25PM -0800, Kees Cook (keescook@chromium.org) wrote:
> While PROC_CN_MCAST_LISTEN/IGNORE is entirely advisory, it was possible
> for an unprivileged user to turn off notifications for all listeners by
> sending PROC_CN_MCAST_IGNORE. Instead, require the same privileges as
> required for a multicast bind.

Sounds resonable.
Not sure whether this is a candidate for stable release, but otherwise
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
