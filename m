Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaDVWKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:10:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaDVWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:10:22 -0400
Date: Wed, 23 Apr 2014 01:10:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] Staging: rts5139: Use standard pr_<level>
 prefixing
Message-ID: <20140422221010.GR26890@mwanda>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
 <1398201784-7602-5-git-send-email-fabio.falzoi84@gmail.com>
 <20140422220757.GQ26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422220757.GQ26890@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 01:07:57AM +0300, Dan Carpenter wrote:
> On Tue, Apr 22, 2014 at 11:23:02PM +0200, Fabio Falzoi wrote:
> > Define pr_fmt macro to prefix every pr_<level> function in standard way.
> > 
> 
> In the end we will want to remove all these debugging messages.

Ah.  I see that you do remove some in a later patch.

Fine fine.  I have no problems with this patchset.  Seems like a nice
cleanup.  Thanks.

regards,
dan carpenter

