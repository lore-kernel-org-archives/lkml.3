Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaIJNzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:55:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36619 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaIJNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:55:16 -0400
Date: Wed, 10 Sep 2014 19:25:05 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: "Kershner, David A" <David.Kershner@unisys.com>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Message-ID: <20140910135505.GA30082@sudip-PC>
References: <1410259269-27397-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E7@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFC97127E0E7@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 08:29:26AM -0500, Romer, Benjamin M wrote:
> On Tue, 2014-09-09 at 16:11 +0530, Sudip Mukherjee wrote:
> > fixed sparse warning : context imbalance in 'resume_device'
> >                         unexpected unlock
> > this patch will generate warning from checkpatch for
> > lines over 80 character , but since those are user-visible strings
> > so it was not modified.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> I tested your changes, and this patch works fine. Thanks!
> 
> -- Ben
> 
> Acked-by: Benjamin Romer <benjamin.romer@unisys.com>
> Tested-by: Benjamin Romer <benjamin.romer@unisys.com>

thanks,
so after Greg K-H applies it then the patch to remove the last warning from this file.

thanks
sudip
