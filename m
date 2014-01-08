Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaAHXy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:54:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAHXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:54:52 -0500
Date: Wed, 8 Jan 2014 15:55:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: MonamAgarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, peter.p.waskiewicz.jr@intel.com,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com
Subject: Re: [PATCH 1/2] Staging: lustre: Fix line length exceeding 80
 characters
Message-ID: <20140108235522.GB20259@kroah.com>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
 <1388953851.5808.31.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388953851.5808.31.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 12:30:51PM -0800, Joe Perches wrote:
> On Mon, 2014-01-06 at 01:41 +0530, MonamAgarwal wrote:
> > This patch fixes the following checkpatch.pl warning in
> > lustre/ldlm/interval_tree.c
> > WARNING: line over 80 characters in the file
> []
> > diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
> []
> > @@ -429,7 +429,8 @@ static void interval_erase_color(struct interval_node *node,
> >  					struct interval_node *o_left;
> >  					o_left = tmp->in_left;
> >  					if (o_left)
> > -						o_left->in_color = INTERVAL_BLACK;
> > +						o_left->in_color =
> > +							INTERVAL_BLACK;
> 
> Likely this function would be better off with some
> refactoring instead of straining to fit 80 cols.

I agree, if you are doing things like this, that's a huge hint that the
code needs fixing.

thanks,

greg k-h
