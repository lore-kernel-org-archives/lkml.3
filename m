Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaGZURL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:17:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaGZURG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:17:06 -0400
Date: Sat, 26 Jul 2014 13:17:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: torresariass@gmail.com
Cc: devel@driverdev.osuosl.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Trivial Patch Monkey <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Tugce Sirin <ztugcesirin@gmail.com>
Subject: Re: [PATCH] wlan-ng:prism2sta: Changes reporting format to meet
 checkpatch.pl
Message-ID: <20140726201706.GA24646@kroah.com>
References: <1406405364-30340-1-git-send-email-torresariass@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406405364-30340-1-git-send-email-torresariass@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 04:09:24PM -0400, torresariass@gmail.com wrote:
> From: Santiago Torres <torresariass@gmail.com>
> 
> [linux-next]: Make the format strings for netdev_err shorter so they can
> fit under the 80 column width requirement.

We do not have that requirement for strings at all, so no need to make
this change.

greg k-h
