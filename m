Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaI3TpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:45:16 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38884 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaI3TpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:45:15 -0400
Date: Tue, 30 Sep 2014 20:45:10 +0100
From: Mark Einon <mark@einon.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mark Einon <mark.einon@gmail.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] et131x: Promote staging et131x driver to drivers/net
Message-ID: <20140930194510.GC1982@msilap.einon.net>
References: <1412104572-2931-1-git-send-email-mark.einon@gmail.com>
 <20140930193201.GA2349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930193201.GA2349@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:32:01PM -0700, Greg KH wrote:
> 
> This is a fine way to make a patch, but it's no way that any of the
> netdev developers could ever review it to know what the code happens to
> look like in my staging-next branch :(
> 
> How about just sending a patch that adds the driver to drivers/net/...
> Don't worry about the staging driver at the moment.  If it gets added to
> drivers/net we can then delete the staging driver.
> 
> Sound easier?  Should make the patches half as big.

Sounds resonable, will do.

Cheers,

Mark
