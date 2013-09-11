Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3IKRPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:15:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39224 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147Ab3IKRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:15:13 -0400
X-Sasl-enc: I1lEmXytarHXD1TRi00hGhWW1aC2Hj5MLIlT8lqdo2d0 1378919709
Date: Wed, 11 Sep 2013 10:15:08 -0700
From: Greg KH <gregkh@linux.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: introduce kobj_completion
Message-ID: <20130911171508.GA29741@kroah.com>
References: <5230A1AE.401@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5230A1AE.401@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:00:30PM -0400, Jeff Mahoney wrote:
> A common way to handle kobject lifetimes in embedded in objects with
> different lifetime rules is to pair the kobject with a struct completion.
> 
> This introduces a kobj_completion structure that can be used in place
> of the pairing, along with several convenience functions for
> initialization, release, and put-and-wait.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  include/linux/kobj_completion.h |   18 ++++++++++++++

Does this really need a new .h file, or can we just cram it into
kobject.h?  It's only 13 more lines to add to that file.

thanks,

greg k-h
