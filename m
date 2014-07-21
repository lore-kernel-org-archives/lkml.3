Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbaGUTTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:19:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbaGUTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:19:05 -0400
Date: Mon, 21 Jul 2014 12:19:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: monamagarwal123@gmail.com, paul.gortmaker@windriver.com,
        jg1.han@samsung.com, paulmck@linux.vnet.ibm.com,
        valentina.manea.m@gmail.com, jack@suse.cz, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: sep: Solves some problems reported by
 checkpatch
Message-ID: <20140721191904.GA3706@kroah.com>
References: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405791282-28023-2-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405791282-28023-2-git-send-email-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 07:34:39PM +0200, LABBE Corentin wrote:
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/staging/sep/sep_main.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

_which_ specific problems are fixed here?

Please be specific and provide a valid changelog entry in the body of
the email, changelogs without any information other than the subject:
are generally frowned apon.

Can you please fix this up and resend?

thanks,

greg k-h
