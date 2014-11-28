Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaK1WPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:15:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:15:42 -0500
Date: Fri, 28 Nov 2014 14:14:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: devel@driverdev.osuosl.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
Message-ID: <20141128221419.GA27558@kroah.com>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
 <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
 <20141126215801.GA32756@kroah.com>
 <20141127132657.GA12298@firebird>
 <20141127152417.GB23247@kroah.com>
 <20141127155706.GB24149@kroah.com>
 <20141127195054.GA14536@firebird>
 <20141128203248.GA26878@kroah.com>
 <20141128205705.GA8278@firebird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128205705.GA8278@firebird>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 09:57:06PM +0100, Mariusz Gorski wrote:
> > I tried to apply the 3rd, but it didn't apply due to patches I applied
> > in your first set of 4 patches.
> > 
> > Does that help?
> 
> Yes, thanks. I've resent the patchset yesterday as v3:
> https://lkml.org/lkml/2014/11/27/805
> 
> It applies cleanly to current staging-testing (aa9d9be),
> I've just retested it. Please give it a try.

Thanks, I'll do that when I get around to applying staging patches
again, sometime next week, I'm supposed to be on vacation right now...

greg k-h
