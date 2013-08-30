Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3H3Pjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:39:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3H3Pjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:39:41 -0400
Date: Fri, 30 Aug 2013 08:42:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130830154205.GA1411@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830124622.5f81b7d4@rechenknecht2k7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:46:22PM +0200, Benjamin Valentin wrote:
> Samsung released their exFAT (and FAT12/16/32) driver under the GPLv2, it is
> based on the in-kernel FAT driver and can be obtained from [1].
> This patch adds version 1.2.4 of the exfat driver, sans the ifdefs for older
> kernel versions and ported to Linux 3.11.
> 
> [1] http://opensource.samsung.com search for exfat
> 
> original authors: Joosun Hahn
> 		  Sung-Kwan Kim
> 
> Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>

For staging drivers I need a maintainer that is going to take the time
to shephard it into the core kernel tree.  See other TODO files for
how that person is defined.  Are you going to be willing to do this?

If so, can you please resend it with those changes to the TODO file, and
add a MAINTAINERS file entry?

Also, I would really like to get a signed-off-by: from the Samsung
authors for this patch, can you do that as well please?

thanks,

greg k-h
