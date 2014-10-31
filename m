Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbaJaUvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:51:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33930 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbaJaUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:51:38 -0400
X-Sasl-enc: xB+VfBP/D7OcaDtcGRUDNwY6SDUve4gE2T++2pAR0Bn4 1414788697
Date: Fri, 31 Oct 2014 13:50:24 -0700
From: Greg KH <greg@kroah.com>
To: Balavasu <kp.balavasu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: Re: [PATCH 1/2] staging: lustre: lnet: lnet: do not initialise
 statics to 0 or NULL
Message-ID: <20141031205024.GB20417@kroah.com>
References: <20141031181808.GA7830@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031181808.GA7830@vasu-Inspiron-3542>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:48:08PM +0530, Balavasu wrote:
> This patch fixes the checkpatch.pl issue
> Error: do not initialise statics to 0 or NULL for time
> 
> Signed-off-by: Balavasu <kp.balavasu@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/do not instalise 0 | 10 +++++-----

That line doesn't look right, does it?

And why netdev and not the mailing list for the drivers/staging/ tree?

And again, I need a full name.

greg k-h
