Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3ARVCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:02:17 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60573 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3ARVCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:02:15 -0500
Date: Fri, 18 Jan 2013 13:02:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>
Subject: Re: [PATCH 1/3] wlan-ng/prism2mgmt.c: added parenthesis to macro
Message-ID: <20130118210211.GC12463@kroah.com>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
 <1358464052-14002-2-git-send-email-qi50dube@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358464052-14002-2-git-send-email-qi50dube@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:07:30AM +0100, Sebastian Ehrenfels wrote:
> From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
> 
> Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
> Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de> 

Why did you do this?  What does this fix?  Please always say that in the
change log entry part of the patch, empty ones aren't ok.

And why do you have trailing spaces on your signed-off-by: lines?

thanks,

greg k-h
