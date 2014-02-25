Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBYA7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:59:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBYA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:59:06 -0500
Date: Mon, 24 Feb 2014 17:00:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] Staging: comedi: addi-data: fix a couple of lines
 that are too long
Message-ID: <20140225010039.GA31031@kroah.com>
References: <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
 <1393259709-18516-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393259709-18516-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:35:09AM -0600, Chase Southwood wrote:
> There are a couple of cases where a comment being on the same line as a
> statement is causing the line to be over 80 characters long.  This is an
> easy fix, move these comments to the previous line.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> 
> ---
> 2: Some changes to PATCH 2/3 v2 occurred in the immediate context of
> changes in this patch.  I've redone this patch after updating PATCH 2/3
> so that it still applies cleanly.

Thank you for noticing and fixing this up before I hit it, much
appreciated.

greg k-h
