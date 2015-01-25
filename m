Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbbAYQTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:19:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbbAYQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:49 -0500
Date: Sun, 25 Jan 2015 20:41:00 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
Subject: Re: [PATCH char-misc-next v2 01/13] misc: mic: SCIF header file and
 IOCTL interface
Message-ID: <20150125124100.GB21763@kroah.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
 <8ff5b107eeabad618e07c156ec541409b9f88c6a.1421097390.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ff5b107eeabad618e07c156ec541409b9f88c6a.1421097390.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:55PM -0800, Sudeep Dutt wrote:
> + * Errors:
> + * EBADF, ENOTTY
> + * epd is not a valid endpoint descriptor
> + * ECONNREFUSED
> + * The destination was not listening for connections or refused the
> + *	connection request
> + * EINVAL
> + * epd is not a valid endpoint descriptor, or
> + * dst.port is not a valid port ID
> + * EISCONN
> + * The endpoint is already connected
> + * ENOMEM
> + * No buffer space is available
> + * ENODEV
> + * The destination node does not exist, or
> + * The node is lost or existed, but is not currently in the network since it
> + *	may have crashed
> + * ENOSPC
> + * No port number available for assignment
> + * EOPNOTSUPP
> + * The endpoint is listening and cannot be connected
> +*/

Very odd formatting of these error codes here, and other places in this
.h file, please fix them all up and properly wrap your lines.

thanks,

greg k-h
