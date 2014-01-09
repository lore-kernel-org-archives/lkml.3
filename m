Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaAISpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:45:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbaAISpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:45:35 -0500
Date: Thu, 9 Jan 2014 10:46:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <csouth3@illinois.edu>
Cc: linux-kernel@vger.kernel.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: comedi: replace printk() calls with dev_dbg()
 in pcmmio.c
Message-ID: <20140109184605.GA22848@kroah.com>
References: <1388189241-4367-1-git-send-email-csouth3@illinois.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388189241-4367-1-git-send-email-csouth3@illinois.edu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:07:21PM -0600, Chase Southwood wrote:
> From: Chase Southwood <csouth3@illinois.edu>
> 
> Changed several printk() calls to dev_dbg() or dev_err() in pcmmio.c to fix checkpatch.pl warnings.  Patched from 3.13-rc5.

Please line-wrap your changelog entries.

Also, this is already fixed up in my tree, please always work against
linux-next, what is in Linus's tree is pretty old for staging stuff.

Care to redo this against linux-next and resend it?

thanks,

greg k-h
