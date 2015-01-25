Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbbAYQPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbbAYQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:37 -0500
Date: Sun, 25 Jan 2015 19:51:23 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: devel@driverdev.osuosl.org, gdonald@gmail.com, tapaswenipathak@gmail.com,
        yejiayily@gmail.com, mcgrof@do-not-panic.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, joe@perches.com
Subject: Re: [PATCH RESEND 2 1/4] staging: rtl8192u: fix comments
Message-ID: <20150125115123.GA12175@kroah.com>
References: <1421577420-10115-1-git-send-email-lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421577420-10115-1-git-send-email-lstoakes@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 10:36:57AM +0000, Lorenzo Stoakes wrote:
> This patch fixes errors raised by checkpatch.pl relating to use of C99 comments
> in r8192U_dm.c, and cleans up existing ANSI C comments.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_dm.c | 811 ++++++++++++++++++-----------------
>  1 file changed, 420 insertions(+), 391 deletions(-)

This patch fails to apply to my staging-testing branch of staging.git,
so I can't apply it :(

Please refresh your series and resend.

thanks,

greg k-h
