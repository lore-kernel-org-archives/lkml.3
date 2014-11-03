Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaKCVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:22:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaKCVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:22:17 -0500
Date: Mon, 3 Nov 2014 13:22:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 10/10] added kernel build, configuration, and TODO files
Message-ID: <20141103212216.GC7379@kroah.com>
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
> +++ b/drivers/staging/mausb/drivers/Makefile
> @@ -0,0 +1,20 @@
> +#MY_CFLAGS =-g -O0 -DEBUG_OUTPUT

Please remove that line, it's not ever to be used.


