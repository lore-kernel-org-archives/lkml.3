Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3EPTBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:01:24 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34528 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3EPTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:01:21 -0400
Date: Thu, 16 May 2013 15:01:30 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: kernel-janitors@vger.kernel.org, andreas.dilger@intel.com,
        tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix return type of lo_release.
Message-ID: <20130516190130.GB2778@kroah.com>
References: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 06:06:20PM +0200, Cyril Roelandt wrote:
> The return type of block_device_operations.release() changed to void in commit
> db2a144b.

Interesting, how did you test build this patch, given that the driver
doesn't currently build at all?  :)

Anyway, thanks, I'll go queue this up.

greg k-h
