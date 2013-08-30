Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3H3RHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:07:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63205 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3H3RHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:07:42 -0400
Date: Fri, 30 Aug 2013 10:07:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Drop support for Renesys H8/300 architecture
Message-ID: <20130830170739.GA9301@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
 <1377882069.2070.28.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377882069.2070.28.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:01:09AM -0700, Joe Perches wrote:
> On Fri, 2013-08-30 at 09:40 -0700, Guenter Roeck wrote:
> > H8/300 has been dead for several years, the kernel for it has
> > not compiled for ages, and recent versions of gcc for it are broken.
> > It is time to drop support for it.
> 
> Adding Yoshinori Sato <ysato@users.sourceforge.jp>
> just in case the MAINTAINER address is still alive.
> 
Should have been copied, but I think I misspelled it. Sorry for that.
I'll add an explicit Cc: to the patches for the next version.

Guenter
