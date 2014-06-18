Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaFRRjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:39:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47155 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbaFRRja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:39:30 -0400
X-Sasl-enc: 8a+tCZ8MIZJwjLm/lJAIfJ3zqrjYSb9bDwH/7Y/g3Tuu 1403113169
Date: Wed, 18 Jun 2014 10:43:28 -0700
From: Greg KH <greg@kroah.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: kamal.mostafa@canonical.com, perex@perex.cz, tiwai@suse.de,
        eldad@fogrefinery.com, clemens@ladisch.de, tim.gardner@canonical.com,
        stern@rowland.harvard.edu, linux@eikelenboom.it,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v3.13.y][SRU][PATCH 0/1] ALSA: usb-audio: Prevent printk
 ratelimiting from spamming kernel log while DEBUG not defined
Message-ID: <20140618174328.GB11977@kroah.com>
References: <cover.1400085278.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1400085278.git.joseph.salisbury@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:14:05PM -0400, Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1319457
> 
> Hello,
> 
> Please consider including upstream commit b7a77235 in the next v3.13.y release.  It was included upstream as of v3.15-rc5.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1319457 .

Please get a good email client and wrap your lines :(

> commit b7a7723513dc89f83d6df13206df55d4dc26e825
> Author: Sander Eikelenboom <linux@eikelenboom.it>
> Date:   Fri May 2 15:09:27 2014 +0200
> 
>     ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
> 
> 
> This commit does not apply cleanly to v3.13, so I performed a backport, which is in email 1/1. 

Any reason this shouldn't also be in 3.14-stable?

thanks,

greg k-h
