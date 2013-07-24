Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3GXR2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:28:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3GXR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:28:37 -0400
Date: Wed, 24 Jul 2013 10:28:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH-RESEND 8/8] staging/lustre: fix errno translate code on
 non-x86
Message-ID: <20130724172836.GA1740@kroah.com>
References: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
 <1374686251-3152-9-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374686251-3152-9-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:17:31AM +0800, Peng Tao wrote:
> On non-x86 we will build with Lustre's errno translate code but
> it has a few issues that break build on non-x86 platforms.
> 
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> ---
>  drivers/staging/lustre/lustre/ptlrpc/Makefile |    2 +-
>  drivers/staging/lustre/lustre/ptlrpc/errno.c  |    4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)

As this fixes a build error exposed by a patch earlier in this series,
why not reorder them to prevent any build error at all?

I'll just take the first 5 in this series for now because of this.

thanks,

greg k-h
