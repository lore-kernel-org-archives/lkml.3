Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaCFGXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:23:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaCFGXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:23:07 -0500
Date: Wed, 5 Mar 2014 22:23:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Fred Akers <knivey@botops.net>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: range: remove unnecessary sanity check
Message-ID: <20140306062333.GA19862@kroah.com>
References: <53176DC0.9070503@mev.co.uk>
 <1394086023-10852-1-git-send-email-knivey@botops.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394086023-10852-1-git-send-email-knivey@botops.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:07:03AM -0500, Fred Akers wrote:
> This check is unnecessary because range_table will always be
> initialized to range_unknown by comedi_device_postconfig() for
> drivers that do not initialize range_table or range_table_list
> 
> Signed-off-by: Fred Akers <knivey@botops.net>
> ---
> Apply this after first patch

What "first" patch?

If you have patches that need a sequence, then send a series of patches,
all numbered, like git will export for you, so I know for sure that I've
gotten them all, and that they are in the correct order.

You don't want me to have to guess :)

Care to try again?

thanks,

greg k-h
