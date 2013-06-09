Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3FIF2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 01:28:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FIF2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 01:28:10 -0400
Date: Sat, 8 Jun 2013 22:28:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Laura Lawniczak <laura.lawniczak@googlemail.com>
Cc: devel@driverdev.osuosl.org, Kurt Kanzenbach <shifty91@gmail.com>,
        linux-kernel@i4.cs.fau.de, Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>
Subject: Re: [PATCH] keucr: removed unnecessary variables and comments
Message-ID: <20130609052844.GA31124@kroah.com>
References: <20130606215721.GA24059@kroah.com>
 <1370610509-32432-1-git-send-email-laura.lawniczak@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370610509-32432-1-git-send-email-laura.lawniczak@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:08:29PM +0200, Laura Lawniczak wrote:
> blen and bn were only used in commented code fragments.
> since comments should be informative and not for storing old
> code, both, commented code and variables, were removed.
> 
> Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
> Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
> ---
>  drivers/staging/keucr/transport.c |   15 ---------------
>  1 file changed, 15 deletions(-)

This patch doesn't apply to my tree, can you please redo it against my
latest tree and resend it?

thanks,

greg k-h
