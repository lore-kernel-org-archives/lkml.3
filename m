Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaFRV7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:59:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaFRV7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:59:31 -0400
Date: Wed, 18 Jun 2014 23:59:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: Neaten message logging
In-Reply-To: <1403117049.3839.21.camel@joe-AO725>
Message-ID: <alpine.LNX.2.00.1406182358320.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz> <1403117049.3839.21.camel@joe-AO725>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Joe Perches wrote:

> Use a more current style to prefix "floppy: " on
> all messages.
> 
> Convert DPRINT to emit at KERN_DEBUG.
> 
> Other miscellaneous logging changes:
> 
> o Add missing newline
> o Remove embedded "floppy" style prefixes

Why is this a good change?

[ ... ]
>  	if (!req) {
> -		pr_info("floppy.c: no request in request_done\n");
> +		pr_info("no request in request_done\n");

I think that in cases like this (and elsewhere where you are changing it 
in your patch) the prefix is actually useful.

-- 
Jiri Kosina
SUSE Labs
