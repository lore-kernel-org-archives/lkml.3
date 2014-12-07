Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaLGUIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:08:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaLGUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:08:37 -0500
Date: Sun, 7 Dec 2014 12:08:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH] staging: writeboost: Add dm-writeboost
Message-ID: <20141207200834.GA2322@kroah.com>
References: <5484498E.4000202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5484498E.4000202@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 09:35:26PM +0900, Akira Hayakawa wrote:
> --- /dev/null
> +++ b/drivers/staging/writeboost/TODO
> @@ -0,0 +1,47 @@
> +TODO:
> +
> +- Expose bugs and fix them.
> +- Clean up the interfaces. Some input values should be limited in case user may choose too big values.
> +- Wait for proper review by Mike Snitzer.
> +- Fix up documents.
> +
> +-------------------------------------------------------------------------
> +
> +Project Ideas:
> +
> +1. Add read caching feature
> +Device-Mapper maintainer Mike Snitzer said that
> +a single target should provide caching for both reads and writes.
> +(cf. http://www.redhat.com/archives/dm-devel/2014-January/msg00078.html)
> +
> +To follow Mike's guide, I will implement read-caching for Writeboost.
> +The great idea is, at least conceptually,
> +sending back the read data to the write entrance.
> +I didn't notice this simple idea at that time of previous discussion.
> +
> +This should be done background and
> +some threshold to determine
> +which sequence of data should be staged.
> +
> +This feature will be implemented step-by-step.
> +I don't think this feature will change then interface drastically.
> +
> +2. Improve initialization time
> +Some user complains that the initialization is too slow.
> +
> +Any ideas?
> +
> +3. Reduce metadata footprint
> +Writeboost has a hash table in RAM for cache management.
> +This isn't cheap.
> +
> +Any ideas?
> +
> +-------------------------------------------------------------------------
> +
> +Please send any patches
> +To:
> +Akira Hayakawa <ruby.wktk@gmail.com>
> +Cc:
> +Greg Kroah-Hartman <greg@kroah.com>

Greg Kroah-Hartman <gregkh@linuxfoundation.org> please, and also the
driverdevel mailing list, which is where the rest of the staging patches
go.

And, I'll need an ack from the dm maintainers before I can accept this
as something they think is ok and will get merged to the "real" part of
the kernel someday.

thanks,

greg k-h
