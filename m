Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbaJ2Ps0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:48:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329AbaJ2Plz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:55 -0400
Date: Wed, 29 Oct 2014 16:37:30 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, heenasirwani@gmail.com,
        bergwolf@gmail.com, amir.shehata@intel.com, gdonald@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/02] staging:lustre:lnet:selftest: fix sparse
 warnings
Message-ID: <20141029083730.GA16144@kroah.com>
References: <cover.1414517099.git.antonysaraev@gmail.com>
 <d5f02315b6e410bc677be4787762403cb3c75c2a.1414517099.git.antonysaraev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5f02315b6e410bc677be4787762403cb3c75c2a.1414517099.git.antonysaraev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:50:18PM +0400, Anton Saraev wrote:
> Fix sparse warnings: symbol X was not declared. Should it be static?
> Some functions used only in files where they are declared. They can
> be static.
> 
> Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
> ---
>  drivers/staging/lustre/lnet/selftest/conctl.c    | 34 ++++++++--------
>  drivers/staging/lustre/lnet/selftest/conrpc.c    | 20 +++++-----
>  drivers/staging/lustre/lnet/selftest/framework.c | 50 ++++++++++++------------
>  drivers/staging/lustre/lnet/selftest/module.c    |  6 +--
>  drivers/staging/lustre/lnet/selftest/rpc.c       | 34 ++++++++--------
>  drivers/staging/lustre/lnet/selftest/timer.c     |  8 ++--
>  6 files changed, 76 insertions(+), 76 deletions(-)

This patch adds a build warning to the build, so I can't apply it.
Please fix it up and resend.

thanks,

greg k-h
