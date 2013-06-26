Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3FZSix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:38:52 -0400
Date: Wed, 26 Jun 2013 11:38:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Subject: Re: [PATCH] zcache: initialize module properly when zcache=FOO is
 given
Message-ID: <20130626183851.GA10591@kroah.com>
References: <1372258142-7019-1-git-send-email-mhocko@suse.cz>
 <20130626150116.GA6004@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130626150116.GA6004@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:01:16AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 26, 2013 at 04:49:02PM +0200, Michal Hocko wrote:
> > 835f2f51 (staging: zcache: enable zcache to be built/loaded as a module)
> > introduced in 3.10-rc1 has introduced a bug for zcache=FOO module
> > parameter processing.
> > 
> > zcache_comp_init return code doesn't agree with crypto_has_comp which
> > uses 1 for the success unlike zcache_comp_init which uses 0. This
> > causes module loading failure even if the given algorithm is supported:
> > [    0.815330] zcache: compressor initialization failed
> > 
> > Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Looks OK to me.
> 
> Cc-ing Greg.

That's nice, but can someone resend it in a format that I can apply it
in, with your ack?

thanks,

greg k-h
