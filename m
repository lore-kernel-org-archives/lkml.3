Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaC1SsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:48:23 -0400
Received: from tex.lwn.net ([70.33.254.29]:35516 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaC1SsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:48:22 -0400
Date: Fri, 28 Mar 2014 12:49:01 -0600
From: Jake Edge <jake@edge2.net>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jade Bilkey <herself@thefumon.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: fix bcm/hostmibs.c checkpatch problems
Message-ID: <20140328124901.6371fa1a@quetzal.lan>
In-Reply-To: <1395596709.13968.30.camel@joe-AO722>
References: <20140322095044.5d4d5ed6@quetzal.lan>
	<1395596709.13968.30.camel@joe-AO722>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2014 10:45:09 -0700 Joe Perches wrote:
> On Sat, 2014-03-22 at 09:50 -0600, Jake Edge wrote:
> > Fix 4 checkpatch errors, many warnings in bcm/hostmibs.c
> 
> Making code checkpatch clean shouldn't be the primary goal here.

Perhaps not, but it was *my* goal :)

> Removing uses of Hungarian-style notation, CamelCase naming, and
> long variable names would be more helpful overall.

I don't have enough experience to feel comfortable about doing that
yet, but I did take some of your suggestions and am respinning the
patch ...

thanks,

jake 

-- 
Jake Edge - jake@edge2.net - http://www.edge2.net
