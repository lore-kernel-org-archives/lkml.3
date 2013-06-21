Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161319Ab3FUBsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:48:24 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43543 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161164Ab3FUBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:48:22 -0400
Date: Thu, 20 Jun 2013 18:48:28 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] gpio: msm-v1: Remove errant __devinit to fix compile
Message-ID: <20130621014828.GA859@quad.lixom.net>
References: <1370373600-31921-1-git-send-email-sboyd@codeaurora.org>
 <CACRpkdZ5x3q9tn3J5_mQj-nJ_wO3HWgX5DTMQdMzF3mUDrAieQ@mail.gmail.com>
 <51BF43F4.9000007@codeaurora.org>
 <CACRpkdZ=VbMUBfHt-GruTzc5_7vF508XFAW50YZb4ouG1TrjZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ=VbMUBfHt-GruTzc5_7vF508XFAW50YZb4ouG1TrjZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:16:17AM +0200, Linus Walleij wrote:
> On Mon, Jun 17, 2013 at 7:14 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 06/16/13 22:54, Linus Walleij wrote:
> >> On Tue, Jun 4, 2013 at 9:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >>
> >>> Commit 7bce696 (gpio: Make gpio-msm-v1 into a platform driver,
> >>> 2013-03-04) was based on an older kernel where __devinit still
> >>> existed. Remove the erroneous __devinit marking.
> >>>
> >>> Cc: David Brown <davidb@codeaurora.org>
> >>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> Patch applied.
> >
> > Thanks. It looks like David picked this up and sent it off to arm-soc
> > last week. Cc'ing Olof for awareness of a possible duplicate.
> 
> Did that get ack by some GPIO maintainer?
> 
> This needs to go through the GPIO tree, but I
> guess GIT will survive if it ends up in two trees.

Nope, and it slipped through the cracks. More and more patches that we see lack
proper acks, and it's becoming a problem. I have to go search for them on the
lists and see if they came in without being tagged on the patch, etc.

Time to get more strict on that, obviously. :(

But yeah, one duplicate trivial patch like this shouldn't be an issue.


-Olof
