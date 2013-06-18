Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3FRSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:33:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34951 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab3FRSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:33:30 -0400
Date: Tue, 18 Jun 2013 21:32:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/4 v3] silicom: checkpatch: assignments in if conditions
Message-ID: <20130618183200.GQ5008@mwanda>
References: <1371496539-25461-1-git-send-email-lorenz@badgers.com>
 <1371572918-25493-1-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371572918-25493-1-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:28:38PM +0200, Lorenz Haspel wrote:
> Fixes checkpatch error:
> There were assignments in if conditions, so I extracted them.
> 
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>

Looks good, thanks.

regards,
dan carpenter

