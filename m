Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbbAQO7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:59:55 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60076 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbbAQO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:59:54 -0500
X-Sasl-enc: 443ELx6Thq5slq7ZQQX3LIm6pGSuVmuppiNY9bpcj+Gb 1421506793
Date: Sat, 17 Jan 2015 06:59:51 -0800
From: Greg KH <greg@kroah.com>
To: Heinz Diehl <htd+ml@fritha.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.18.3
Message-ID: <20150117145951.GB26836@kroah.com>
References: <20150116183905.GA15290@kroah.com>
 <20150117080519.GA1863@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150117080519.GA1863@fritha.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 09:05:19AM +0100, Heinz Diehl wrote:
> On 16.01.2015, Greg KH wrote: 
> 
> > I'm announcing the release of the 3.18.3 kernel.
> 
> Since 3.18, machines with Ironlake Intel Graphics are left with a
> black screen when booting into X. I reported the bug here:
> 
> https://www.libreoffice.org/bugzilla/show_bug.cgi?id=87330
> 
> And there are several reports of the same bug in the Bugzilla.
> The problem is fixed in current mainline, but still present in
> 3.18.3. The patch which fixes the problem is attached, maybe it should
> be applied to -stable as well?

It's already in my queue of patches to apply, if you notice, I haven't
applied any drm patches for 3.18-stable yet, as I haven't had the chance
to get to them yet.

thanks for your patience,

greg k-h
