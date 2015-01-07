Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbbAGSMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:12:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbbAGSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:12:22 -0500
Date: Wed, 7 Jan 2015 10:12:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: sakshi <sakshi.april5@gmail.com>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar, shack@linux.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed line over 80 characters warning
Message-ID: <20150107181221.GA6644@kroah.com>
References: <1420650446-21507-1-git-send-email-sakshi.april5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420650446-21507-1-git-send-email-sakshi.april5@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:37:26PM +0530, sakshi wrote:
> Signed-off-by: sakshi <sakshi.april5@gmail.com>

Your subject needs to provide a little bit more data, as what part of
the kernel you are modifying, and the like.  Look at existing patches
for examples of this.

Also, we need a changelog body, saying what you are doing.

And finally, we need a "full" name for the From: and signed-off-by:
line, I doubt you sign legal documents with just those 6 letters, right?

Please fix up and resend.

thanks,

greg k-h
