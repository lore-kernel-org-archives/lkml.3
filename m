Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaGGNFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:05:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbaGGNFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:05:53 -0400
Date: Mon, 7 Jul 2014 15:05:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Nicholas Krause <xerofoify@gmail.com>, jejb@parisc-linux.org,
        deller@gmx.de, tiwai@suse.de, dave.anglin@bell.net, joe@perches.com,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: Remove sizeof(frame) from call to get_sigframe
In-Reply-To: <20140707135554.1c52342c@alan.etchedpixels.co.uk>
Message-ID: <alpine.LNX.2.00.1407071504380.1655@pobox.suse.cz>
References: <1404530457-4739-1-git-send-email-xerofoify@gmail.com> <20140707135554.1c52342c@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014, One Thousand Gnomes wrote:

> > This removes the sizeof(frame) from the call to get_sigframe on line
> > 243 in order to fix the call to this function as the sizeof in not
> > needed to call this function.
> 
> If you are going to submit patches then
> 
> - actually read what you are submitting
> 
> - check it actually compiles
> 
> - run it on the system in question and verify your changed code paths are
>   used
> 
> *then* consider submitting it, otherwise all you are doing is wasting
> people's time.

Seconded. Nicholas, this is a third time I've seen patch from you in my 
mailbox that didn't make any sense whatsoever. Please be more careful, 
once certain reputation is gained, it's very difficult to escape it.

-- 
Jiri Kosina
SUSE Labs
