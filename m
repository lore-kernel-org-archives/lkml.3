Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaKCVYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:24:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaKCVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:24:05 -0500
Date: Mon, 3 Nov 2014 13:24:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 10/10] added kernel build, configuration, and TODO files
Message-ID: <20141103212404.GD7379@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-11-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415047377-3139-11-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:42:57PM -0800, Stephanie Wallick wrote:
> --- /dev/null
> +++ b/drivers/staging/mausb/TODO
> @@ -0,0 +1,14 @@
> +TODO:
> +	- checkpatch.pl cleanups

Is this still true?

And why does this need to be a staging driver?  What's wrong with making
it a "real" driver now?


> +	- address miscellaneous "TODO" statements in code
> +	- add support for multiple media agnostic (MA) devices
> +	- add/improve support for unimplemented packet types
> +	- handle errors and failure with more grace and less crash
> +
> +Please send patches to Greg Kroah-Hartman <greg@kroah.com> and cc:

You didn't use this email address...

> +	Sean Stalley <sean.stalley@intel.com>
> +	Stephanie Wallick <stephanie.s.wallick@intel.com>
> +

Just make a MAINTAINERS entry please for this info.

thanks,

greg k-h
