Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaEWSnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaEWSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:43:05 -0400
Date: Fri, 23 May 2014 21:09:15 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: andreas.dilger@intel.com, green@linuxhacker.ru, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lnet: klnds: Remove prohibited space in
 socklnd.c
Message-ID: <20140523120915.GA7924@kroah.com>
References: <1400711013-15957-1-git-send-email-massa.nomura@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400711013-15957-1-git-send-email-massa.nomura@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:23:33PM +0100, Masaru Nomura wrote:
> Remove prohibited space between function name and open parenthesis
> to meet kernel coding style. Also, fix indenting due to changes.
> 
> Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
> ---
>  .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  230 ++++++++++----------
>  1 file changed, 116 insertions(+), 114 deletions(-)

This patch doesn't apply either, please refresh and resend.

thanks,

greg k-h
