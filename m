Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3C1WxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:53:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62149 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3C1WxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:53:03 -0400
Date: Thu, 28 Mar 2013 15:53:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Adrian Chadd <adrian@freebsd.org>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@adurom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kathy Giori <Kathy.Giori@qca.qualcomm.com>,
        Yanbo Li <dreamfly281@gmail.com>,
        Mathieu Olivari <mathieu@qca.qualcomm.com>, k.eugene.e@gmail.com
Subject: Re: Possibility for an external staging tree - bring up quality code
Message-ID: <20130328225300.GA20285@kroah.com>
References: <CAB=NE6WLuz7-QD3v4BwZkLLNUed=X7jgvZtZX8cDEh3HiD51oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6WLuz7-QD3v4BwZkLLNUed=X7jgvZtZX8cDEh3HiD51oQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 01:13:23PM -0700, Luis R. Rodriguez wrote:

<huge snip>

> This has me thinking if it makes sense to have an external driver tree
> for staging drivers but lead by engineers who already know the rules
> of upstream, they just want to get things done faster.

That's called a "fork" or "tree" or whatever you want to call it, and
all of us have them, and end up merging stuff to mainline through them
eventually.

There is no need to "codify" something that we all have been doing for
years.  If someone thinks they can "work faster" in their own tree,
great for them, have them do it.  I don't see what I need to agree or
disagree with here to keep anyone from doing such a thing.

Or am I just totally missing something here?

greg k-h
