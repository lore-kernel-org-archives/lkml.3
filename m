Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3CRX60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:58:26 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:56073 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3CRX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:58:24 -0400
Date: Mon, 18 Mar 2013 16:59:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 28/44] tty: Remove ldsem recursion support
Message-ID: <20130318235940.GB5320@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-29-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363034704-28036-29-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:44:48PM -0400, Peter Hurley wrote:
> Read lock recursion is no longer required for ldisc references;
> remove mechanism.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ldsem.c   | 83 +++++------------------------------------------
>  include/linux/tty_ldisc.h |  2 --
>  2 files changed, 8 insertions(+), 77 deletions(-)

Wait, why did you add something 3 patches ago, only to remove it here?
Why not just smush these patches together in the first place?

greg k-h
