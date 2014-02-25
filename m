Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaBYAPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:15:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaBYAPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:15:40 -0500
Date: Mon, 24 Feb 2014 16:17:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Mason <jdmason@kudzu.us>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/dt3155v4l: use PCI_VENDOR_ID_INTEL
Message-ID: <20140225001712.GA27103@kroah.com>
References: <1393272500-1862-1-git-send-email-jdmason@kudzu.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393272500-1862-1-git-send-email-jdmason@kudzu.us>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 01:08:19PM -0700, Jon Mason wrote:
> Use PCI_VENDOR_ID_INTEL instead of creating its own vendor ID #define.
> 
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/media/dt3155v4l/dt3155v4l.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

$ ./scripts/get_maintainer.pl --file drivers/staging/media/dt3155v4l/dt3155v4l.c
Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:MEDIA INPUT INFRA...,commit_signer:5/6=83%)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:STAGING SUBSYSTEM,commit_signer:1/6=17%)
Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:5/6=83%,authored:4/6=67%,added_lines:7/9=78%,removed_lines:5/10=50%)
Jingoo Han <jg1.han@samsung.com> (commit_signer:1/6=17%,authored:1/6=17%,added_lines:1/9=11%,removed_lines:1/10=10%)
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> (commit_signer:1/6=17%)
Russell King <rmk+kernel@arm.linux.org.uk> (authored:1/6=17%,added_lines:1/9=11%,removed_lines:4/10=40%)
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

I am not the person to send this to, please use the tools we have to
determine who to send patches to so they can get properly applied.

thanks,

greg k-h
