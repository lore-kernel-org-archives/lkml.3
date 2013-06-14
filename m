Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3FNQWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:22:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3FNQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:22:43 -0400
Date: Fri, 14 Jun 2013 09:23:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>, chris@chris-wilson.co.uk
Subject: Re: [PATCH 0/3]
Message-ID: <20130614162319.GB14829@kroah.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
 <87d2rzl4qp.fsf@intel.com>
 <20130613082205.GL22870@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613082205.GL22870@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:22:05AM +0200, Daniel Vetter wrote:
> On Thu, Jun 06, 2013 at 04:59:26PM +0300, Jani Nikula wrote:
> > 
> > With Greg's address fixed. Please drop the old one from any
> > replies. Sorry for the noise.
> 
> Oops, replied with the old one still there.
> 
> Greg, Andrew: Imo it's best to merge all three patches through the same
> tree, so:
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> on the i915 parts of it. If you want I can also slurp them in through the
> intel tree, including the new dmi match code.

Please feel free to take them through your tree, I don't need to take
them.

thanks,

greg k-h
