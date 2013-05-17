Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3EQDus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:50:48 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33251 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3EQDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:50:45 -0400
Date: Thu, 16 May 2013 17:58:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130517005855.GA5873@kroah.com>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
 <20130506105352.GA23051@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506105352.GA23051@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:53:52PM +0200, Pavel Machek wrote:
> Hello!
> 
> > This adds ability to bind uio driver to given open firmware device
> > using command line option. Thus, userspace driver can be developed and
> > used without modifying the kernel.
> > 
> > Signed-off-by: Pavel Machek <pavel@denx.de> 
> 
> I got no comments here, and patch is pretty simple. Greg, can you
> merge it?

Hans is handling UIO patches, Hans?
