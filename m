Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJJLlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:41:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaJJLlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:41:46 -0400
Date: Fri, 10 Oct 2014 04:40:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: William Dauchy <william@gandi.net>
Cc: stable@vger.kernel.org, linux@roeck-us.net, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3.12 00/96] 3.12.30-stable review
Message-ID: <20141010114047.GB32429@kroah.com>
References: <cover.1412147522.git.jslaby@suse.cz>
 <CAJ75kXb-mmrW9n51O19rM4xz1i_qTBjzAkOzfY5brWW4TEig1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXb-mmrW9n51O19rM4xz1i_qTBjzAkOzfY5brWW4TEig1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 09:32:45AM +0200, William Dauchy wrote:
> Hi stable release team,
> 
> On Wed, Oct 1, 2014 at 10:57 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> > This one is special. First, it is rounded (30). Second, most of the
> > patches are performance improvements. They are coming from SUSE
> > Enterprise Linux and all are backed by proper testing and performance
> > measurements. All this patchset was prepared and sent by Mel Gorman
> > with a support of other patchers from SUSE. Thanks to all of them.
> 
> I'm just wondering if 3.10.x and 3.14.x are going to benefit from
> these performance improvement patches as well.

The last 3.14.x release had a bunch of these patches already in them,
with more to come in future releases, so yes, 3.14.x is going to benefit
from it, and you didn't even notice :)

But 3.10 will probably not, it's been just too long for that kernel
release, sorry, major mm changes like this isn't something I'm willing
to do at this point in time.

Hope this helps,

greg k-h
