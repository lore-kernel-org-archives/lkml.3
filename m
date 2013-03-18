Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3CRXwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:52:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3CRXwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:52:47 -0400
Date: Mon, 18 Mar 2013 16:54:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 00/44] ldisc patchset
Message-ID: <20130318235402.GA1937@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:44:20PM -0400, Peter Hurley wrote:
> Greg,
> This patchset includes
>   'tty: Drop lock contention stat from ldsem trylocks'
> so no need to apply that on this series. Also, I noticed you
> kept the 'tty is NULL' removal on a different branch so I left
> my patch in this series that removes it.
> 
> This series applies cleanly to tty-next.

I've applied the first 25 patches, right up to the "create a new lock"
patch.  I'll comment on that one next.

thanks,

greg k-h
