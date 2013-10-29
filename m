Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3J2REk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:04:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3J2REj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:04:39 -0400
Date: Tue, 29 Oct 2013 10:04:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: Staging subsystem List <devel@driverdev.osuosl.org>,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 02/11 V2] Staging: bcm: Remove typedef for _U_IP_ADDRESS
 and call directly.
Message-ID: <20131029170437.GA18702@kroah.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
 <1383018708-29615-3-git-send-email-klmckinney1@gmail.com>
 <20131029160148.GA20656@kroah.com>
 <20131029160322.GA21844@kroah.com>
 <CAKPrQY9OTnJMEZ9=PhwXDbSxaKwt0t1A1HEFmCde-x-WDXDPoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPrQY9OTnJMEZ9=PhwXDbSxaKwt0t1A1HEFmCde-x-WDXDPoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 01:01:39PM -0400, Kevin McKinney wrote:
> Sure, I will resend these patches.  I tried to be careful, and apply all other
> patches before I re-did mine. I must have missed something. I will resend. In
> the past I developed my patches against the linux-next branch.  Is this still
> the right branch to use?

Yes it is.

thanks,

greg k-h
