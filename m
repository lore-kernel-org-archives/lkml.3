Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab3CEAe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:34:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59664 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3CEAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:34:57 -0500
Date: Tue, 5 Mar 2013 08:30:10 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drivers/crypto/nx: fix init race, alignmasks and GCM bug
Message-ID: <20130305003010.GD23819@kroah.com>
References: <CAM0nabG9SeyX7t77CABiDAzECrWa9g2bRmBTjfeoWFjFE8gPiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0nabG9SeyX7t77CABiDAzECrWa9g2bRmBTjfeoWFjFE8gPiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:44:57AM -0600, Kent Yoder wrote:
>   Fixes a race on driver init with registering algorithms where the
> driver status flag wasn't being set before self testing started.
> 
>   Added the cra_alignmask field for CBC and ECB modes.
> 
>   Fixed a bug in GCM where AES block size was being used instead of
> authsize.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> ---
>  drivers/crypto/nx/nx-aes-cbc.c | 1 +
>  drivers/crypto/nx/nx-aes-ecb.c | 1 +
>  drivers/crypto/nx/nx-aes-gcm.c | 2 +-
>  drivers/crypto/nx/nx.c         | 4 ++--
>  4 files changed, 5 insertions(+), 3 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
