Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab3GWUjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:39:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab3GWUjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:39:04 -0400
Date: Tue, 23 Jul 2013 13:39:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Leibovici <thomas.leibovici@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 35/48] staging/lustre/lmv: support DNE with HSM.
Message-ID: <20130723203903.GA4765@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-36-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-36-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:06:56AM +0800, Peng Tao wrote:
> From: Thomas Leibovici <thomas.leibovici@cea.fr>
> 
> Send HSM requests to the appropriate MDT. Split lists of fids of HSM
> actions into one list per MDT.
> Move kuc registration/unregistration from MDC to LMV as this is not
> MDT related.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3365
> Lustre-change: http://review.whamcloud.com/6714
> Signed-off-by: Thomas Leibovici <thomas.leibovici@cea.fr>
> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  drivers/staging/lustre/lustre/llite/llite_mmap.c |   36 +++++++++++++---------
>  1 file changed, 21 insertions(+), 15 deletions(-)

This has the exact same Subject: as patch 34, which implies that one of
these is wrong, so I'll not take either, sorry.

Please fix up and resend.

greg k-h
