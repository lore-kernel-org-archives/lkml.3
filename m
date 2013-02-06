Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3BFQjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:39:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36753 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3BFQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:39:06 -0500
Date: Wed, 6 Feb 2013 16:33:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, js1304@gmail.com
Subject: Re: [PATCH RESEND] ARM: sched: correct update_sched_clock()
Message-ID: <20130206163355.GH17833@n2100.arm.linux.org.uk>
References: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com> <CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 10:33:53AM +0100, Linus Walleij wrote:
> On Wed, Feb 6, 2013 at 6:21 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > If we want load epoch_cyc and epoch_ns atomically,
> > we should update epoch_cyc_copy first of all.
> > This notify reader that updating is in progress.
> 
> If you think the patch is finished, put it into Russell's patch tracker:
> http://www.arm.linux.org.uk/developer/patches/

Yea, this patch looks like the right thing... and yes, into the patch
system please.
