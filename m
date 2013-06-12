Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3FLHKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:10:05 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:40807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3FLHKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:10:02 -0400
Message-ID: <1371020996.8601.7.camel@jlt4.sipsolutions.net>
Subject: Re: pull request: wireless 2013-06-06
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 09:09:56 +0200
In-Reply-To: <20130612.000711.759531077550828193.davem@davemloft.net>
References: <20130606190929.GB18827@tuxdriver.com>
	 <20130611.222706.1492583255605214982.davem@davemloft.net>
	 <1371018409.8601.2.camel@jlt4.sipsolutions.net>
	 <20130612.000711.759531077550828193.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 00:07 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 12 Jun 2013 08:26:49 +0200
> 
> > On Tue, 2013-06-11 at 22:27 -0700, David Miller wrote:
> >> From: "John W. Linville" <linville@tuxdriver.com>
> >> Date: Thu, 6 Jun 2013 15:09:30 -0400
> >> 
> >> > Johannes Berg (2):
> >> >       mac80211: constify ieee802_11_parse_elems() argument
> >> 
> >> Such cleanups are absolutely, positively, not appropriate at this
> >> time.
> > 
> > My other fix depends on this to not have a const warning. I can add a
> > cast to pretend the input isn't const at this point, but that seemed
> > like a bad idea as well.
> 
> I would combine the two changes into one commit, because then this
> necessity is clear and you can even explain this in the commit message
> so that there is no argument about the justification.

Sure, I can do that too.

johannes


