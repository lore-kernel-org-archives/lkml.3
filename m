Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbaJaUvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:51:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39852 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbaJaUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:51:48 -0400
X-Sasl-enc: dE5Rv3QH2GxMjqrh3qPwRS071qMdXnrYUxHY/H42PThQ 1414788708
Date: Fri, 31 Oct 2014 13:50:36 -0700
From: Greg KH <greg@kroah.com>
To: Balavasu <kp.balavasu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: Re: [PATCH 2/2] staging: lustre: lnet: lnet: trailing statements
 should be on next line
Message-ID: <20141031205036.GC20417@kroah.com>
References: <20141031182040.GA7916@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031182040.GA7916@vasu-Inspiron-3542>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:50:40PM +0530, Balavasu wrote:
> This patch fixes the checkpatch.pl issue
> Error: trailing statements should be on next line
> 
> Signed-off-by: Balavasu <kp.balavasu@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/router.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Same comments as 1/2
