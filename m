Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaGONyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:54:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaGONyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:54:32 -0400
Date: Tue, 15 Jul 2014 06:54:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sam-the-6 <asadi.samuel@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 91/93] Staging: comedi: 8253.h fixed by removing 'return'
 from generic func
Message-ID: <20140715135410.GA18292@kroah.com>
References: <1405393999-25927-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405393999-25927-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:13:19AM +0300, sam-the-6 wrote:
> From: Sam Asadi <asadi.samuel@gmail.com>
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>

Where are the other 90 patches in this series, I only received 91, 92,
93, and 94.  Wait, 94 out of 93????  What is going on here?

> 
> 	modified:   drivers/staging/comedi/drivers/8253.h

What is this line for?

Also, please look at your email client's "From:" line up above, it isn't
matching your From: and Signed-off-by: line in the body of the patch,
why?

thanks,

greg k-h
