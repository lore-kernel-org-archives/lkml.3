Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbaCSBCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:02:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaCSBCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:02:33 -0400
Date: Tue, 18 Mar 2014 18:04:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlags49_h2: Coding style correction
Message-ID: <20140319010436.GA19180@kroah.com>
References: <1395190329-7720-1-git-send-email-mathieu.maret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395190329-7720-1-git-send-email-mathieu.maret@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 01:52:09AM +0100, Mathieu Maret wrote:
> As the file was mixing tab and space, reindent the file
> Mainly correct use of C99 comments,
> space between parenthesis,
> remove commented code
> 
> Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
> ---
>  drivers/staging/wlags49_h2/wl_netdev.c | 1990 ++++++++++++++++----------------
>  1 file changed, 1007 insertions(+), 983 deletions(-)

That's way too big to review easily, can you do that?  :)

Please break it up into "do one thing at a time" type patch, so that it
can be reviewed and applied properly.

thanks,

greg k-h
