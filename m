Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbbAQWdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:33:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAQWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:33:32 -0500
Date: Sat, 17 Jan 2015 14:23:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: devel@driverdev.osuosl.org, gdonald@gmail.com, tapaswenipathak@gmail.com,
        yejiayily@gmail.com, mcgrof@do-not-panic.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, joe@perches.com
Subject: Re: [PATCH RESEND 1/4] staging: rtl8192u: fix comments
Message-ID: <20150117222314.GA29474@kroah.com>
References: <1420899554-14120-1-git-send-email-lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420899554-14120-1-git-send-email-lstoakes@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 02:19:11PM +0000, Lorenzo Stoakes wrote:
> This patch fixes errors raised by checkpatch.pl relating to use of C99 comments
> in r8192U_dm.c, and cleans up existing ANSI C comments.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_dm.c | 811 ++++++++++++++++++-----------------
>  1 file changed, 420 insertions(+), 391 deletions(-)

This doesn't apply against my latest staging-testing branch, so I can't
accept it.  Please refresh this series against that branch and resend.

thanks,

greg k-h
