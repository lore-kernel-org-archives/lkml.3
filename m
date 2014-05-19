Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaEST52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:57:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaEST50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:57:26 -0400
Date: Mon, 19 May 2014 22:57:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to
 debugfs
Message-ID: <20140519195708.GY15585@mwanda>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
 <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
 <20140518164918.GA10285@kroah.com>
 <C97001BC43954D438ACB059713BA5CDFA47DDAD93D@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFA47DDAD93D@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 09:42:22AM -0500, Romer, Benjamin M wrote:
> On Sun, 2014-05-18 at 09:49 -0700, Greg KH wrote:
> > Also, why are these entries moving to debugfs at all?  Why are they
> > needed?  Who will use them?  Are tools relying on them to be there?
> 
> The tuning entries are sometimes used to help adjust the behavior of our
> IO service partitions for better performance.

That sounds like it really belongs in sysfs instead of debugfs.

regards,
dan carpenter

