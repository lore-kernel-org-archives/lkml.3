Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaHSPYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:24:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41283 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaHSPYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:24:36 -0400
Date: Tue, 19 Aug 2014 08:24:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 18
Message-ID: <20140819152426.GA19665@roeck-us.net>
References: <20140818133259.3d1182fd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818133259.3d1182fd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 01:32:59PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add code intended for v3.18 until after v3.17-rc1 is
> released.
> 
> Changes since 20140815:
> 
> The sound-asoc tree gained a build failure for which I reverted a commit.
> 
> The regulator tree gained a build failure so I used the verison from
> next-20140815.
> 
> The staging tree gained a build failure for which I applied a fix patch.
> 
> Non-merge commits (relative to Linus' tree): 1010
>  955 files changed, 25072 insertions(+), 21100 deletions(-)
> 
Something in this tree appears to be completely broken. All my qemu tests
fail with it. It _seems_ that the problem is related to either mount related
or to locking related code. Someone might want to have a look. Given that
all of my runtime tests crash, it is probably easy to reproduce by just
trying to load an image on an x86 system.

Guenter
