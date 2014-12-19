Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaLSPnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:43:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaLSPnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:43:02 -0500
Date: Fri, 19 Dec 2014 07:43:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sage Vaillancourt <sagev9000@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, chase.southwood@gmail.com,
        ebru.akagunduz@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 544/544] Staging: comedi: fix spacing style issues in
 ni_stc.h This is a patch to the ni_stc.h file that removes spaces before
 tabs, and adds blank lines after declarations.
Message-ID: <20141219154301.GC19077@kroah.com>
References: <1418980771-17690-1-git-send-email-sagev9000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418980771-17690-1-git-send-email-sagev9000@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 04:19:31AM -0500, Sage Vaillancourt wrote:
> ---
>  drivers/staging/comedi/drivers/ni_stc.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Odd subject there, don't you think?

And where are the 543 other patches you sent out that need to be applied
before this one?  :)

Please fix this up and run your patch through checkpatch before sending
it out so that people don't tell you to fix things that an automated
tool will tell you about...

thanks,

greg k-h
