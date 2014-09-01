Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaIATNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:13:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaIATN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:13:29 -0400
Date: Mon, 1 Sep 2014 12:12:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Move out of staging
Message-ID: <20140901191245.GA7905@kroah.com>
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
 <20140901123320.GC4707@distanz.ch>
 <5404C292.9030908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5404C292.9030908@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:01:38PM +0300, Eli Billauer wrote:
> Hello Tobias,
> 
> Thanks for that heads-up. I'll make a separate patch for MAINTAINERS if and
> when the driver goes out of staging. No point risking the failure to apply
> the major patch because of a clash on MAINTAINERS.

You can send me a patch for MAINTAINERS now, no reason why staging
drivers can't have listed MAINTAINERS entries (a number of them already
do.)

thanks,

greg k-h
