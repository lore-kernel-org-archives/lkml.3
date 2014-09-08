Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaIHPc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:32:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42815 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbaIHPcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:32:54 -0400
X-Sasl-enc: 1SOcdMn1ehzflSr1v6yFh1f51DLJe+XBxcKo9Uf/VnVR 1410190045
Date: Mon, 8 Sep 2014 08:27:24 -0700
From: Greg KH <greg@kroah.com>
To: Peter Kieser <peter@kieser.ca>
Cc: Francis Moreau <francis.moro@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Message-ID: <20140908152724.GB32677@kroah.com>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk>
 <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com>
 <20140905214532.GA30221@kroah.com>
 <540A44A3.5060502@kieser.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540A44A3.5060502@kieser.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:17:55PM -0700, Peter Kieser wrote:
> 
> On 2014-09-05 2:45 PM, Greg KH wrote:
> >Just because a maintainer/developer doesn't want to do anything for the
> >stable kernel releases does_NOT_  mean the code is
> >"unstable/expreimental" at all.
> 
> These are more bcache-ate-my-data unstable bugs. It's standard practice to
> backport fixes that cause instability/data corruption to a 'stable' release
> (otherwise, why would it be named 'stable')?

That's fine, but it has nothing to do with what sounded like someone
wanting to go back and mark an older kernel feature as "unsupported".

greg k-h
