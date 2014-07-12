Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaGLBaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:30:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGLBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:30:16 -0400
Date: Fri, 11 Jul 2014 18:34:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712013444.GA30368@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405128087.6751.12.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> A simple script to run checkpatch --fix for various types of
> of cleanups.
> 
> This script is useful primarily for staging.
> 
> This reformats code to a more CodingStyle conforming style,
> compiles it, verifies that the object code hasn't changed,
> and git commits it too.

And 'git commits' it?  Heh, I should just run this myself to clean up
staging and beat everyone else to it...

I know some people already have private versions of these things, might
as well make it public for all to abuse :)

thanks,

greg k-h
