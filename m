Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3I1WOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 18:14:11 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46689 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3I1WOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 18:14:08 -0400
Date: Sun, 29 Sep 2013 01:14:02 +0300
From: Elad Wexler <elad.wexler@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        elad.wexler@gmail.com
Subject: Re: [PATCH] misc: cs5535-mfgpt: Replace 'module_init' with
 'module_platform_driver'
Message-ID: <20130928221400.GA4630@gmail.com>
References: <1380392082-23572-1-git-send-email-elad.wexler@gmail.com>
 <CAFLxGvzWsr7RCtxOcZ2LO1dSmjt0Khr91JAcM_NykCYRtd2R8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzWsr7RCtxOcZ2LO1dSmjt0Khr91JAcM_NykCYRtd2R8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 08:54:55PM +0200, richard -rw- weinberger wrote:
> On Sat, Sep 28, 2013 at 8:14 PM,  <elad.wexler@gmail.com> wrote:
> > From: Elad Wexler <elad.wexler@gmail.com>
> >
> > Driver doesn't do anything special in 'module_init'.
> >
> > 'module_platform_init' makes the code more readable.
> >
> > Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
> 
> NAK.
> 
> By moving to module_platform_init() you make this module unloadable.
> Currently it is unloadable for good reasons.
> The cs5535-mfgpt chip is nasty because it has no reliable reset function.
> Therefore by unloading and loading the module again bad things can happen.
> 
I think this HW information should be well documented.
Explaining the reason why it doesn't implemented the 'module_exit'

> -- 
> Thanks,
> //richard
