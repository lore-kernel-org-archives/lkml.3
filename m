Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab3FXXOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:14:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FXXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:14:02 -0400
Date: Mon, 24 Jun 2013 16:14:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 2/2 v3] silicom: checkpatch: assignments in if conditions
Message-ID: <20130624231400.GA17306@kroah.com>
References: <20130618183212.GA8182@kroah.com>
 <1371631444-27789-1-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371631444-27789-1-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:44:04AM +0200, Lorenz Haspel wrote:
> Fixes checkpatch error:
> There were assignments in if conditions, so I extracted them.
> 
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
> ---
> v2: removed some buggy extra lines and fixed white space issues
> v3: fixed some more extra lines

This patch doesn't apply at all to my tree :(

greg k-h
