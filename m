Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaESWWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:22:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaESWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:22:35 -0400
Date: Mon, 19 May 2014 15:22:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jake Edge <jake@lwn.net>
Cc: Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/1] staging/skein: rename files and clean up
 directory structure
Message-ID: <20140519222224.GA9907@kroah.com>
References: <20140518125615.2df48ea9@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140518125615.2df48ea9@chukar.edge2.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 12:56:15PM -0600, Jake Edge wrote:
> 
> Clean up file names and locations.  Get rid of include/ directory and move
> those up to the top-level.  Rename files to get rid of upper case.  Remove
> skeinBlockNo3F.c as it was unused (temporary file or something?).
> 
> Signed-off-by: Jake Edge <jake@lwn.net>

Can you resend this now against my staging-next branch?  I didn't take
Anton's version of this patch as it wasn't as "complete" as this one
was.

thanks,

greg k-h
