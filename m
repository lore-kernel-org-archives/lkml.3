Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3H2BSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:18:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58879 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3H2BSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:18:53 -0400
Date: Wed, 28 Aug 2013 18:18:49 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Message-ID: <20130829011848.GA16891@teo>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
 <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130828083630.GF19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:36:30AM +0300, Dan Carpenter wrote:
> He doesn't want to take the patch.  He's the maintainer so it's his
> choice.  That's the end of the story.

Just to clarify: I don't want to take the patch for a reason, not just
because of my mood today. Once the patch comes in combination with another
patch (or a plan) that actually makes use of the wrapper function, then
I'd happily apply/ack it.

This is the same story as global checkpatch.pl fixes: they are more harm
than good, and without the actual use of the dev_get_platdata(), the patch
falls into "global checkpatch.pl fixes" category.

Thanks,

Anton
