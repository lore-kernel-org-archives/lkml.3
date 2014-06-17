Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaFQTVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:21:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45305 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645AbaFQTVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:21:15 -0400
X-Sasl-enc: AoawzFufOOLFK9NDAjpOEnKD/TkW3JtNHZF7PocwVqQb 1403032874
Date: Tue, 17 Jun 2014 12:25:11 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/24] drivers/firmware: return actual error on sysfs init
Message-ID: <20140617192511.GE4628@kroah.com>
References: <53A050BA.9010004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A050BA.9010004@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:29:14PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> This patch fix all sysfs init functions under firmware subsystems
> to return the actual error if call kset_create_and_add() failed.
> 
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  drivers/firmware/dmi-sysfs.c       | 4 +++-
>  drivers/firmware/edd.c             | 4 ++--
>  drivers/firmware/efi/efivars.c     | 4 ++--
>  drivers/firmware/efi/runtime-map.c | 4 ++--
>  drivers/firmware/memmap.c          | 4 ++--
>  5 files changed, 11 insertions(+), 9 deletions(-)

Stefan, please do not take this patch.

thanks,

greg k-h
