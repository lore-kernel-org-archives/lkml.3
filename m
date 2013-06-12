Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3FLG1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:27:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:40699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3FLG07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:26:59 -0400
Message-ID: <1371018409.8601.2.camel@jlt4.sipsolutions.net>
Subject: Re: pull request: wireless 2013-06-06
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 08:26:49 +0200
In-Reply-To: <20130611.222706.1492583255605214982.davem@davemloft.net> (sfid-20130612_072751_104839_5F29BCA5)
References: <20130606190929.GB18827@tuxdriver.com>
	 <20130611.222706.1492583255605214982.davem@davemloft.net>
	 (sfid-20130612_072751_104839_5F29BCA5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 22:27 -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 6 Jun 2013 15:09:30 -0400
> 
> > Johannes Berg (2):
> >       mac80211: constify ieee802_11_parse_elems() argument
> 
> Such cleanups are absolutely, positively, not appropriate at this
> time.

My other fix depends on this to not have a const warning. I can add a
cast to pretend the input isn't const at this point, but that seemed
like a bad idea as well.

johannes


