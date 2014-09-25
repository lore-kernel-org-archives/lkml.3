Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaIYXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:53:27 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62294 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaIYXxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:53:25 -0400
Date: Thu, 25 Sep 2014 16:53:22 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] of: correct of_console_check()'s return value
Message-ID: <20140925235322.GW1193@ld-irv-0074>
References: <1409767603-3290-1-git-send-email-computersforpeace@gmail.com>
 <20140908104238.C7B3DC40AB2@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908104238.C7B3DC40AB2@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, Sep 08, 2014 at 11:42:38AM +0100, Grant Likely wrote:
> On Wed,  3 Sep 2014 11:06:43 -0700, Brian Norris <computersforpeace@gmail.com> wrote:
> > The comments above of_console_check() say that it will return TRUE if it
> > registers a preferred console, but add_preferred_console() uses a
> > 0-equals-success convention, so ths leaves of_console_check() with an
> > inconsistent policy for its return values.
> > 
> > Fortunately, nobody was actually checking the return value of
> > of_console_check(), so this isn't significant at the moment.
> > 
> > But let's match the comments, so we're doing what we say.
> > 
> > Fixes: 3482f2c52b77 ('of: Create of_console_check() for selecting a console specified in /chosen')
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> 
> Good catch. Applied, thanks.

Applied to what? I don't see it in linux-next.

Regards,
Brian
