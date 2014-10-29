Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361AbaJ2Ppf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:45:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071AbaJ2PmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:07 -0400
Date: Wed, 29 Oct 2014 17:22:08 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RESEND] staging: dgap: re-arrange functions for removing
 forward declarations
Message-ID: <20141029092208.GA28631@kroah.com>
References: <20141026020853.GA28838@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141026020853.GA28838@devel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 11:08:54AM +0900, Daeseok Youn wrote:
> Re-arrange the functions for removing forward declarations.
> 
> Tested-by: Mark Hounschell <markh@compro.net>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> RESEND: This patch is tested all by Mark.
> It is good to merge. Greg, check please.

It doesn't apply to my tree :(
