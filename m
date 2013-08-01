Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3HAVtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:49:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3HAVtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:49:04 -0400
Date: Fri, 2 Aug 2013 05:50:19 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Evan Ng <evan.sin.ng@gmail.com>
Cc: pe1dnn@amsat.org, johanmeiring@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlags49_h2: fixed 80 line character and white
 space issue in ap_h2.c Fixed various coding style warnings found by the
 checkpatch.pl tool
Message-ID: <20130801215019.GA4427@kroah.com>
References: <1375303465-3437-1-git-send-email-evan.sin.ng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375303465-3437-1-git-send-email-evan.sin.ng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 01:44:25PM -0700, Evan Ng wrote:
> From: esn89 <evan.sin.ng@gmail.com>

I need a real name here, odds are "esn89" isn't yours :)

Also, look at the subject you created, it's not correct, you need to add
a newline after a short description, followed by the longer description,
for git to pick this up properly.

> Signed-off-by: Evan Ng <evan.sin.ng@gmail.com>
> ---
>  drivers/staging/wlags49_h2/ap_h2.c | 7884 +++++++++++++++++++++---------------
>  1 file changed, 4668 insertions(+), 3216 deletions(-)

That's almos impossible to review, can you do "one thing at a time" so
that we can review it?  Break it up into lots of different pieces and
send a series of patches.

thanks,

greg k-h
