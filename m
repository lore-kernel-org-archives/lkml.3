Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbbAJR6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 12:58:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbAJR6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 12:58:47 -0500
Date: Sat, 10 Jan 2015 09:58:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: devel@driverdev.osuosl.org, gdonald@gmail.com, tapaswenipathak@gmail.com,
        yejiayily@gmail.com, mcgrof@do-not-panic.com, anarey@gmail.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, joe@perches.com
Subject: Re: [PATCH v2 1/4] staging: rtl8192u: fix comments
Message-ID: <20150110175846.GA8427@kroah.com>
References: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 09:10:40PM +0000, Lorenzo Stoakes wrote:
> This patch fixes errors raised by checkpatch.pl relating to use of C99 comments
> in r8192U_dm.c and cleans up existing ANSI C comments.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_dm.c | 811 ++++++++++++++++++-----------------
>  1 file changed, 420 insertions(+), 391 deletions(-)

This patch series is confusing to me as to which ones are the "latest"
ones, can you resend the latest versions so that I have a chance to
figure it out easier?

thanks,

greg k-h
