Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3J3NWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:22:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab3J3NWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:22:01 -0400
Date: Wed, 30 Oct 2013 14:21:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Austad <henrik@austad.us>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Updating 00-INDEX in Documentation/*
In-Reply-To: <20131028130511.GA6992@austad.us>
Message-ID: <alpine.LNX.2.00.1310301420240.21144@pobox.suse.cz>
References: <20131028130511.GA6992@austad.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013, Henrik Austad wrote:

> Hi Rob, Jiri
> 
> If this email goes the wrong place, my sincere apologies, my asbestos 
> underwear can be quickly donned!
> 
> I've been reading through some of the docs and one thing that has struct 
> me, is that there is a certain degree of bitrot (textrot?). Almost every 
> category has an outdated 00-INDEX. A couple of indexes has been updated 
> (thanks for applying Jiri!), but more remains.
> 
> This is obviously not the most important job to undertake, but it 
> serves as a very convenient starting-point when exploring a given topic.
> 
> Hacking away at python shows me that of the 254 subfolders 57 has outdated 
> 00-INDEX, either with missing files, or files that has been removed. (see 
> list below)
> 
> Now, I'm quite happy to start fixing this, but what I would like to know 
> before I start:
> 
> - is it considered a waste of time? i.e. will it be worth the time

That definitely depends purely on you, as you are the sole owner of your 
own time :)

I'd be happy to apply the fixes if you decide to produce them, as keeping 
the references broken isn't really nice.

> - what is best, a single, big patch, or a series of one patch per 
>   directory?

For this particular thing, I'd prefer single big patch. I can handle the 
(very unlikely) conflict cases.

> - or should someone(tm) kick whoever caused 00-INDEX to be outdated, to fix 
>   it?

That's probably more effort than actually fixing it :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
