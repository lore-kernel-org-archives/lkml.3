Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3GNR1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 13:27:08 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52795 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3GNR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 13:27:06 -0400
Date: Sun, 14 Jul 2013 10:27:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
Message-ID: <20130714172703.GA26513@roeck-us.net>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 05:35:58PM -0700, Greg Kroah-Hartman wrote:
> Hi all,
> 
> Here's the second iteration of the patchset to add better attribute
> group support to the driver core and sysfs.
> 
> I've tested these (shocker!) and everything works fine with them (I'm
> sending this from Linus's latest kernel with these 7 on top of it.)
> 
> I'd like to send these to Linus for 3.11 unless someone objects.
> 
Hi Greg,

I have not seen the series in the upstream kernel. Do you have an updated
plan to get it upstream ?

If needed I can carry the patches I need in my branch for now, so it doesn't
matter too much if the code misses 3.11. Still, it would help to know the
plan going forward.

Thanks,
Guenter
