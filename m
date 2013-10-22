Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3JVGBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 02:01:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3JVGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 02:01:42 -0400
Date: Tue, 22 Oct 2013 07:03:05 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: export kobj_sysfs_ops
Message-ID: <20131022060305.GA14982@kroah.com>
References: <52659B24.4030809@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52659B24.4030809@suse.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:22:44PM -0400, Jeff Mahoney wrote:
> struct kobj_attribute implements the baseline attribute functionality
> that can be used all over the place. We should export the ops associated
> with it. I have a series of patches on the linux-btrfs list that depend
> on using kobj_sysfs_ops rather than re-implement them.

If you need this for other patches, would it be easier for you to just
take this patch with the btrfs patches so that there's no dependancy on
my tree for them?

If so, please add:

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

to this patch and pass it on, as I have no objection to it.

thanks,

greg k-h
