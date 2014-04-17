Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaDQDXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:23:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDQDXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:23:45 -0400
Date: Wed, 16 Apr 2014 20:23:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joshua Baldock <joshua.baldock@gmail.com>
Cc: andreas.dilger@intel.com, bergwolf@gmail.com, standby24x7@gmail.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/4] Staging: lustre: Fixed formatting errors in
 lib-types.h identified by checkpatch.pl
Message-ID: <20140417032349.GA14620@kroah.com>
References: <1396426379-90014-1-git-send-email-joshua.baldock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396426379-90014-1-git-send-email-joshua.baldock@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 07:12:56PM +1100, Joshua Baldock wrote:
> Fixed '{' not on same line as struct in file lib-types.h identified by checkpatch.pl
> 
> Signed-off-by: Joshua Baldock <joshua.baldock@gmail.com>
> ---
>  drivers/staging/lustre/include/linux/lnet/lib-types.h | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

This patch didn't apply to my tree for some reason, but the other 4 did,
odd.

greg k-h
