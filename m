Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3ATXHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:07:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3ATXHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:07:54 -0500
Date: Mon, 21 Jan 2013 00:07:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH][trivial] pcmcia: avoid static analysis complaint about
 use-after-free
In-Reply-To: <alpine.LNX.2.00.1301202312420.8225@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1301210007310.8266@pobox.suse.cz>
References: <alpine.LNX.2.00.1301202312420.8225@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2013, Jesper Juhl wrote:

> Coverity complains about a use after free for 'res1' and 'res2' since
> we use the value of the pointers in a 'dev_dbg()' after they have been
> freed. That's not really a problem, but it still seems cleaner to
> defer freeing until we are completely done with the pointers.

Makes sense. I am taking this one.

Thanks,

-- 
Jiri Kosina
SUSE Labs
