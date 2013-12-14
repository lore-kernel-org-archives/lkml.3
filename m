Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3LNT1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:27:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3LNT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:27:03 -0500
Date: Sat, 14 Dec 2013 09:30:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131214173011.GF22520@kroah.com>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214015343.GP31386@dastard>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:53:43PM +1100, Dave Chinner wrote:
> > Ideas?
> 
> Fix the device delete error handling not to re-enter the
> filesystem and IO path. It's just wrong.

That sounds totally reasonable to me, what is preventing someone from
making this change?

thanks,

greg k-h
