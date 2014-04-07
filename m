Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaDGUzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:55:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaDGUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:55:46 -0400
Date: Mon, 7 Apr 2014 13:58:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Move driver_data back to struct device
Message-ID: <20140407205815.GA8043@kroah.com>
References: <20140407105322.2eae6b97@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407105322.2eae6b97@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:53:22AM +0200, Jean Delvare wrote:
> Having to allocate memory as part of dev_set_drvdata() is a problem
> because that memory may never get freed if the device itself is not
> created. So move driver_data back to struct device.
> 
> This is a partial revert of commit b4028437.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Greg, we discussed that back in January (in a thread named "Freeing of
> dev->p") but I did not hear back from you and I can't see this fix in
> your driver-core tree.

Thanks for doing this, I'll queue this up after -rc1 is out.  I still
have that thread in my TODO list, unfortunatly, higher-priority items
keep bumping it down :(

greg k-h
