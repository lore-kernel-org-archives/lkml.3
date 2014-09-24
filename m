Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaIXILn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:11:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaIXILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:11:36 -0400
Date: Tue, 23 Sep 2014 22:59:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/10] mei: enable adding more IOCTL handlers
Message-ID: <20140924055958.GA24238@kroah.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 12:53:19AM +0300, Tomas Winkler wrote:
> Handle ioctls in a switch statement so we can
> add more commands easily
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c | 53 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 28 insertions(+), 25 deletions(-)

If you resend patches, put a "v2" or something in the subject, or a
"RESEND" so I know to catch the newer series.  I applied the older one
without seeing this one.  If that's wrong, please let me know what to do
to fix it up.

thanks,

greg k-h
