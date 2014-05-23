Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaEWSnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:43:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaEWSnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:43:01 -0400
Date: Fri, 23 May 2014 21:07:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: andreas.dilger@intel.com, green@linuxhacker.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] staging: lustre: lnet: klnds: Fix coding style in
 socklnd.c
Message-ID: <20140523120757.GA6540@kroah.com>
References: <1400540603-12039-1-git-send-email-massa.nomura@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400540603-12039-1-git-send-email-massa.nomura@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:03:23AM +0100, Masaru Nomura wrote:
> Remove prohibited space between function name and
> open parenthesis to meet kernel coding style.
> Also fix indenting due to changes to keep readability.
> 
> I undid modifications to memset(...) which I made in
> previous patches as it could be removed based on
> the fact LIBCFS_ALLOC is executed before memset.
> With this, others can notice warnings against memset
> caused by checkpatch.pl and modify it easily.
> 
> Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
> ---
>  .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  238 ++++++++++----------
>  1 file changed, 119 insertions(+), 119 deletions(-)

This patch doesn't apply against my tree anymore.  Can you please
refresh it and resend?

thanks,

greg k-h
