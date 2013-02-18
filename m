Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3BRSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:51:18 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46803 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3BRSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:51:17 -0500
Date: Mon, 18 Feb 2013 10:51:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Berger <git.rber@gmail.com>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org, joe@perches.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: Re: [PATCH 2/4] staging/zache BUILD_MODNAME and checkpatch fixes
Message-ID: <20130218185113.GA24554@kroah.com>
References: <git.rber@gmail.com>
 <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
 <1361003754-22512-3-git-send-email-rber.git@ReliableEmbeddedSystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361003754-22512-3-git-send-email-rber.git@ReliableEmbeddedSystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 10:35:52AM +0200, Robert Berger wrote:
> As per Joe's suggestion:
> "Perhaps it'd be better to use KBUILD_MODNAME all the time
> instead of adding the prefix. Also, to me mixing "ramster: "
> and "zcache: " for the prefixes is odd. Just using zcache
> all the time would be simpler, so remove namestr too."
> 
> checkpatch fixes:
> zcache-main.c:1987: WARNING: quoted string split across lines
> zcache-main.c:2002: WARNING: quoted string split across lines
> 
> Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
> ---
>  drivers/staging/zcache/zcache-main.c |  137 ++++++++++++++++------------------
>  1 file changed, 65 insertions(+), 72 deletions(-)

This patch fails to apply, care to refresh it, and your 2 other patches
in this series, against the linux-next tree, and resend it so that I can
apply it?

thanks,

greg k-h
