Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3GJByv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:54:51 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:34092 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3GJByu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:54:50 -0400
Date: Tue, 09 Jul 2013 20:54:45 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [GIT] Networking
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFxbipsZFC2iQsVchstOP_7mR48sUbo96LEJ4kxtZWQDKQ@mail.gmail.com>
	(from torvalds@linux-foundation.org on Tue Jul  9 12:32:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373421285.27613.36@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 12:32:56 PM, Linus Torvalds wrote:
> On Mon, Jul 8, 2013 at 7:29 PM, Rob Landley <rob@landley.net> wrote:
> >
> > Um, does that mean I should have cc'd you on the initmpfs patch  
> series
> > back before the merge window opened?
> 
> So I personally don't tend to care about that kind of patch-series -
> it doesn't really add new features to basic code unlike the polling
> changes.

I tried to be as non-intrusive as possible while mucking about with  
early boot code on all targets. :)

> But I suspect for something like that series, the people to
> cc are Al Viro and Hugh Dickins because they maintain vfs adn tmpfs
> respectively.. That said, I think neither really cares.deeply, and
> this looks like a "Andrew" patch-series if only because it's so random
> ;)

All three were cc'd by get_maintainer.pl, but none of 'em seem to have  
noticed.

The embedded community continues to have strange needs, but they make  
sense to us. (And oddly enough to the supercomputer folks, who are  
basically "embedded with money".)

Thanks,

Rob