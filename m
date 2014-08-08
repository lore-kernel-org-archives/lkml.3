Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaHHJMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:12:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaHHJMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:12:40 -0400
Date: Fri, 8 Aug 2014 12:10:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: AdrianRemonda <adrianremonda@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] Staging: rtl8188eu: Lines over 80 characters fixed.
Message-ID: <20140808091040.GI4856@mwanda>
References: <1407192303-23519-1-git-send-email-adrianremonda@gmail.com>
 <1407192737.16152.83.camel@joe-AO725>
 <20140807214532.GA11670@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807214532.GA11670@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 11:45:32PM +0200, AdrianRemonda wrote:
> I have resent the changes now. Is this ok? Or should I wait until the merge
> window is close?

Just send your patches.  They will sit in Greg's inbox for a couple
weeks, but that's ok.

> Also N_BYTE_ALIGNMENT is being used by several files in the 8188, should
> I remove this macro?

kmalloc() returns properly aligned pointers.

Look at how N_BYTE_ALIGNMENT() is used and judge each time if it is
needed.

regards,
dan carpenter

