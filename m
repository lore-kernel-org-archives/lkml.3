Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaGKSI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:08:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56165 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbaGKSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:08:55 -0400
X-Sasl-enc: lrWKASObGMEjZlb9xDRYrzyGhMbDmU9sMv2D98DZhdSZ 1405102134
Date: Fri, 11 Jul 2014 11:13:21 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        julia.lawall@lip6.fr, Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [PATCH v3] thunderbolt: Use kcalloc and correct the argument to
 sizeof
Message-ID: <20140711181321.GB25757@kroah.com>
References: <20140708223126.GA12035@himangi-Dell>
 <CAMxnaaX6tOobPBDVbG7v-kJTvNMLYSybZWuzTqbgMdMkP50swQ@mail.gmail.com>
 <CAMxnaaXJ_eYvUwPV=-w_eZW-EChhe1eW5Q5ctru4mhWyt3ZhuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaXJ_eYvUwPV=-w_eZW-EChhe1eW5Q5ctru4mhWyt3ZhuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 07:14:23PM +0200, Andreas Noever wrote:
> Greg, can you add this to your char-misc tree (instead of the kzalloc
> patch, or do you need a rebased patch)?

I need a patch on top of my char-misc tree as the kzalloc version is
already applied there.

thanks,

greg k-h
