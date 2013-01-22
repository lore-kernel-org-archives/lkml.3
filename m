Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3AVKFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:05:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab3AVKFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:05:02 -0500
Date: Tue, 22 Jan 2013 11:04:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v2] HID: add support for Sony RF receiver with USB product
 id 0x0374
In-Reply-To: <50FE2A34.3050607@lab.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1301221103250.20374@pobox.suse.cz>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>  <50F52986.2080002@lab.ntt.co.jp>  <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>  <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz> 
 <50F637D1.8070302@lab.ntt.co.jp>  <alpine.LNX.2.00.1301161141250.14768@pobox.suse.cz> <50FE2A34.3050607@lab.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Fernando Luis Vazquez Cao wrote:

> > > If possible, I would like to get it backported to 3.7-stable (and
> > > possibly 3.2 stable), since without it a whole family of Sony desktop
> > > computers is unusable under Linux out of the box. Should I do it myself
> > > or do you have a process in place for HID stable patches?
> > 
> > If the patch had
> > 
> > 	Cc: stable@vger.kernel.org
> > 
> > in it, it'd be picked for -stable queue automatically.
> 
> I considered doing that but I thought and upstream commit
> ID was needed.

Yes, that's necessary in case you are cherry-picking a commit already 
present in Linus' tree that doesn't have explicit "Cc: 
stable@vger.kernel.org". Otherwise, -stable tree maintainer is 
automatically picking up commits that appear in Linus tree with this tag.

> 
> > Otherwise, anyone is free to take it once it's in Linus' tree and sent 
> > to to stable@vger.kernel.org for inclusion.
> 
> So it is the standard procedure. I just wanted to make sure whether you 
> wanted to have all the -stable patches funnelled through you. 

It's not strictly necessary. I get copied on them when they are queued in 
-stable queue anyway.

> By the way, I will be replying to this email with a follow-up patch that 
> I forgot to send the last time around. It is just documentation for the 
> quirk.

Ok, thanks.

-- 
Jiri Kosina
SUSE Labs
